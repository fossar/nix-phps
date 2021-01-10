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
            self.overlay
          ];
        };
      in {
        packages = {
          inherit (pkgs) php php56 php70 php71 php72 php73 php74 php80;
        };
      }
    ) // {
      overlay = import ./pkgs/phps.nix nixpkgs.outPath;
    };
}
