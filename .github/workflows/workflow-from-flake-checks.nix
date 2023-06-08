# Runs Nix flake checks individually with group markers for GitHub Actions.
# Invoke with `nix-shell workflow-from-flake-checks.nix`

let
  self = import ../..;

  pkgs = self.inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
  inherit (self.inputs.nixpkgs) lib;

  checkAttrs =
    lib.foldl'
      (
        acc:
        {
          name,
          value,
        }:

        acc // {
          "${name}" = {
            inherit (value) description;
            platforms = acc.${name}.platforms or {} // { "${value.platform}" = null; };
            phps = acc.${name}.phps or {} // { "${value.php}" = null; };
          };
        }
      )
      {}
      (
        builtins.concatLists (
          lib.mapAttrsToList
            (
              platform:
              checks:

              lib.mapAttrsToList
                (
                  attr:
                  check:

                  let
                    match = builtins.match "(php[0-9]+)-(.+)" attr;
                  in
                  {
                    name = builtins.head (builtins.tail match);
                    value = {
                      inherit (check) description;
                      inherit platform;
                      php = builtins.head match;
                    };
                  }
                )
                checks
            )
            self.outputs.checks
        )
      );

  packages = self.outputs.packages.${builtins.currentSystem};
  phpPackages = builtins.filter (name: builtins.match "php[0-9]+" name != null) (builtins.attrNames packages);

  workflow = {
    name = "Test";

    on = {
      workflow_call = {
        secrets = {
          CACHIX_AUTH_TOKEN = {
            required = true;
          };
        };
      };
    };

    jobs = {
      test = {
        name = "PHP \${{ matrix.php.branch }}";
        runs-on = "\${{ matrix.os.image }}";
        steps = [
          {
            uses = "actions/checkout@v3";
          }
          {
            name = "Install Nix";
            uses = "cachix/install-nix-action@v18";
          }
          {
            name = "Set up Nix cache";
            uses = "cachix/cachix-action@v10";
            "with" = {
              authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
              name = "fossar";
            };
          }
        ]
        ++ lib.mapAttrsToList
          (
            attr:
            check:

            {
              name = check.description;
              "if" = "\${{ contains(fromJSON('${lib.escape [ "\\" "'" ] (builtins.toJSON (builtins.attrNames check.platforms))}'), matrix.os.platform) && contains(fromJSON('${lib.escape [ "\\" "'" ] (builtins.toJSON (builtins.attrNames check.phps))}'), matrix.php.attr) }}";
              run = "nix-build -A outputs.checks.\${{ matrix.os.platform }}.\${{ matrix.php.attr }}-${attr}";
            }
          )
          checkAttrs
        ;
        strategy = {
          # We want to fix failures individually.
          fail-fast = false;
          matrix = {
            os = [
              {
                image = "ubuntu-latest";
                platform = "x86_64-linux";
              }
            ];
            php =
              builtins.map
                (
                  phpAttr:

                  {
                    branch = lib.versions.majorMinor packages.${phpAttr}.version;
                    attr = phpAttr;
                  }
                )
                phpPackages;
          };
        };
      };
    };
  };
in

pkgs.stdenv.mkDerivation {
  name = "workflow-from-flake-checks";

  buildCommand = ''
    echo 'Please run `nix-shell .github/workflows/workflow-from-flake-checks.nix`, `nix-build` cannot be used.' > /dev/stderr
    exit 1
  '';

  shellHook =
    ''
      set -o errexit
      echo ${lib.escapeShellArgs [ (builtins.toJSON workflow) ]} | ${pkgs.jq}/bin/jq . > .github/workflows/test.yaml
      exit 0
    ''
    ;
}
