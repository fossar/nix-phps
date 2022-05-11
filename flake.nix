{
  description = "Repository of Nix expressions for old PHP versions";

  inputs = {
    # Shim to make flake.nix work with stable Nix.
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-compat, nixpkgs, utils }:
    # For each supported platform,
    utils.lib.eachDefaultSystem (system:
      let
        # Let’s merge the package set from Nixpkgs with our custom PHP versions.
        pkgs = import nixpkgs.outPath {
          config = {
            allowUnfree = true;
          };
          inherit system;
          overlays = [
            self.overlays.default
          ];
        };
      in rec {
        packages = {
          inherit (pkgs) php php56 php70 php71 php72 php73 php74 php80 php81 php82;
        };

        checks =
          let
            phpPackages = builtins.filter (name: builtins.match "php[0-9]+" name != null) (builtins.attrNames packages);

            inherit (pkgs) lib;


            /* AttrSet<phpName, AttrSet<checkName, checkDrv>> */
            checksPerVersion =
              lib.listToAttrs (
                builtins.map
                  (phpName:
                    let
                      php = packages.${phpName};
                      phpVersion = lib.versions.majorMinor php.version;
                      checks = import ./checks.nix {
                        inherit lib php;
                        inherit (pkgs) runCommand;
                      };
                      supportedChecks = lib.filterAttrs (_name: { enabled ? true, ... }: enabled) checks;
                    in
                    {
                      name = phpName;
                      value =
                        lib.mapAttrs
                          (
                            _name:
                            {
                              description,
                              drv,
                              ...
                            }:

                            drv // {
                              description = "PHP ${phpVersion} – ${description}";
                            }
                          )
                          supportedChecks;
                    }
                  )
                  phpPackages
              );
          in
          lib.foldAttrs
            lib.mergeAttrs
            {}
            (
              lib.mapAttrsToList
              (
                phpName:

                lib.mapAttrs'
                  (
                    name:

                    lib.nameValuePair "${phpName}-${name}"
                  )
              )
              checksPerVersion
            );
      }
    ) // {
      overlays.default = import ./pkgs/phps.nix nixpkgs.outPath;
    };
}
