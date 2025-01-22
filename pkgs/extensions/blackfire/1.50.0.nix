{
  stdenv,
  pkgs,
  prev,
}:

let
  version = "1.50.0";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "5.6" = "sha256-QdhhSMn2fexoC8XkO8XvsXsmu6rpcnB/7Zvr1ALW/SE=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "5.6" = "sha256-0G9ay5fv84xoNICyfgQeHKFm16ltxAKAa6VGA2d+02E=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "5.6" = "sha256-O8ymnzeoXsNl1CxVOTyYmrBlz6YU+T+5W5lQwA5uulM=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = { };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = { };
    };
  };

  makeSource =
    { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    assert !isLinux -> (phpMajor != null);
    pkgs.fetchurl {
      url =
        let
          platform = if isLinux then "linux" else "darwin";
          versionSuffix = builtins.replaceStrings [ "." ] [ "" ] phpMajor;
        in
        "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${platform}_${hashes.${system}.system}-php-${versionSuffix}.so";
      hash =
        hashes.${system}.hash.${phpMajor}
          or (throw "php.extensions.blackfire unsupported on PHP ${phpMajor} on ${system}");
    };
in
prev.extensions.blackfire.overrideAttrs (attrs: {
  inherit version;

  src = makeSource {
    system = stdenv.hostPlatform.system;
    phpMajor = pkgs.lib.versions.majorMinor prev.php.version;
  };
})
