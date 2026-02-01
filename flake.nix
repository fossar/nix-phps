{
  description = "Repository of Nix expressions for old PHP versions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Shim to make flake.nix work with stable Nix.
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      forAllSystems =
        fn:
        inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed (
          system:
          fn {
            pkgs = (
              import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
                # Let’s merge the package set from Nixpkgs with our custom PHP versions.
                overlays = [
                  inputs.self.overlays.default
                ];
              }
            );
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
          ;
      };
    in
    {
      packages = forAllSystems ({ pkgs, ... }: phpPackages pkgs);

      checks = forAllSystems (
        { pkgs, system, ... }:
        (import ./checks.nix {
          inherit pkgs system;
          packages = phpPackages pkgs;
        })
      );

      formatter = forAllSystems ({ pkgs, ... }: pkgs.nixfmt-tree);

      overlays.default = import ./pkgs/phps.nix inputs.nixpkgs.outPath;
    };
}
