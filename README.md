# nix-phps

This is a repository of Nix package expressions for old versions of PHP.

> **Warning:** backwards compatibility is not guaranteed, pin this repo if you want to avoid breakage.

## Why?

PHP projects like [selfoss](https://github.com/fossar/selfoss) aim to support Linux distributions that maintain their own forks of no-longer-supported PHP versions (e.g. [Debian](https://wiki.debian.org/PHP)). To be able to test those PHP versions in CI, we need Nix expressions for them. Since [Nixpkgs](https://github.com/NixOS/nixpkgs) avoids unmaintained software, we maintain those expressions here.

## How to use?

We use [Cachix](https://app.cachix.org/cache/fossar) to store `x86_64-linux` binaries of the built packages. Install it as described in its [docs](https://docs.cachix.org/) and then add the cache using `cachix use fossar` if you want to avoid building those PHP packages yourself.

This package is regularly updated to match latest Nixpkgs and the PHP packages use the [same API as those in Nixpkgs](https://nixos.org/manual/nixpkgs/unstable/#sec-php).

The following versions are currently available:

- `php56`
- `php70`
- `php71`
- `php72`
- `php73`
- `php74`
- `php80`
- `php81`
- `php82`

There is also a `php` package which is the alias of the default PHP version in Nixpkgs.

### With niv

Assuming you have [niv](https://github.com/nmattia/niv) installed and initialized in your project, run `niv add fossar/nix-phps`.

Then, you will be able to use the PHP package, e.g. in `shell.nix`:

```nix
{
  sources ? import ./nix/sources.nix
}:

let
  nivOverlay =
    final:
    prev:
    {
      niv = (import sources.niv {}).niv;
    };

  pkgs = import sources.nixpkgs {
    overlays = [
      nivOverlay
    ];
    config = {
    };
  };

  phps = import sources.nix-phps;
in

pkgs.mkShell {
  buildInputs = [
    phps.packages.${builtins.currentSystem}.php

    # for easy updating
    pkgs.niv
  ];
}
```

### With Nix flakes

> **Warning:** Nix flakes are experimental technology, use it only if you are willing to accept that you might need to change your code in the future.

Add this repository to the `inputs` in your `flake.nix`’s:

```nix
  inputs = {
    …
    phps.url = "github:fossar/nix-phps";
  };
```

then, in `outputs`, you will be able to use the PHP package

```nix
  outputs = { self, nixpkgs, phps, ... }: {
    devShell.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = [
        phps.packages.x86_64-linux.php
      ];
    };
  };
```
