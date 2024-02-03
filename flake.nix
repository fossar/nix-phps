{
  description = "Repository of Nix expressions for old PHP versions";

  inputs = {
    flake-compat.url = "github:nix-community/flake-compat";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs@{ self, flake-parts, nixpkgs, systems, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { self', inputs', config, pkgs, system, lib, ... }: {
      _module.args.pkgs = import self.inputs.nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
        ];
        config.allowUnfree = true;
      };

      packages = {
        inherit (pkgs) php php56 php70 php71 php72 php73 php74 php80 php81 php82 php83;
      };

      checks = import ./checks.nix {
        inherit (self') packages;
        inherit pkgs system;
      };
    };

    flake = {
      overlays.default = import ./pkgs/phps.nix nixpkgs;
    };
  };
}
