{
  description = "Repository of Nix expressions for old PHP versions";

  inputs = {
    # Shim to make flake.nix work with stable Nix.
    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      flake-compat,
      nixpkgs,
    }:
    let
      pkgss = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          # Let’s merge the package set from Nixpkgs with our custom PHP versions.
          overlays = [
            self.overlays.default
          ];
        }
      );

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      forAllSystemsWithPkgs =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f {
            pkgs = pkgss.${system};
            inherit system;
          }
        );

      phpPackages = pkgs: {
        inherit (pkgs)
          php
          php56
          php70
          php71
          php72
          php73
          php74
          php80
          php81
          php82
          php83
          php84
          php85
          ;
      };
    in
    {
      packages = forAllSystemsWithPkgs ({ pkgs, ... }: phpPackages pkgs);

      checks = forAllSystemsWithPkgs (
        { pkgs, system, ... }:
        (import ./checks.nix {
          inherit pkgs system;
          packages = phpPackages pkgs;
        })
      );

      formatter = forAllSystemsWithPkgs ({ pkgs, ... }: pkgs.nixfmt-tree);

      overlays.default = import ./pkgs/phps.nix nixpkgs.outPath;
    };
}
