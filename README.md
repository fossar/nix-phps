# nix-phps

This is a repository of Nix package expressions for old versions of PHP.

> [!CAUTION]
> Do not use versions other than the [currently supported ones](https://www.php.net/supported-versions.php) for public facing services. The older versions contain many security vulnerabilities and we do not have resources to backport security fixes. They are provided for development purposes only.

> [!WARNING]
> Backwards compatibility is not guaranteed, pin this repo if you want to avoid breakage.

## Why?

PHP projects like [selfoss](https://github.com/fossar/selfoss) aim to support Linux distributions that maintain their own forks of no-longer-supported PHP versions (e.g. [Debian](https://wiki.debian.org/PHP)). To be able to test those PHP versions in CI, we need Nix expressions for them. Since [Nixpkgs](https://github.com/NixOS/nixpkgs) avoids unmaintained software, we maintain those expressions here.

## How to use?

We use [Cachix](https://app.cachix.org/cache/fossar) to store `x86_64-linux` binaries of the built packages. Install it as described in its [docs](https://docs.cachix.org/) and then add the cache using `cachix use fossar` if you want to avoid building those PHP packages yourself.

This package is regularly updated to match latest Nixpkgs and the PHP packages use the [same API as those in Nixpkgs](https://nixos.org/manual/nixpkgs/unstable/#sec-php).

The following versions are currently available:

- `php56` **INSECURE!**
- `php70` **INSECURE!**
- `php71` **INSECURE!**
- `php72` **INSECURE!**
- `php73` **INSECURE!**
- `php74` **INSECURE!**
- `php80` **INSECURE!**
- `php81`
- `php82`
- `php83`
- `php84`

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
