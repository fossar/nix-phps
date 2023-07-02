{
  stdenv,
  pkgs,
  prev
}:

let
  version = "1.88.1";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.0" = "sha256-ZxtXJL7fKMxZeRYFr+CX6UnyN1i8RP+BxRQAIQyY/Ko=";
        "7.4" = "sha256-NEj77n1T4nnEW2XTxvWNaZnEd1IOw+xtVe4v9CSKuJk=";
        "7.3" = "sha256-9WLqOSxs235Nuxv+dThVoHGdNGqEhXkHRz3gUxt772Q=";
        "7.2" = "sha256-WQ95ZpjrtTcEc4g+aBWPEkUSopLu3CnABZ+2pr1NkfU=";
        "7.1" = "sha256-KggDQONObIjOMb13ZSjKuKUMnhQ55vtO64YVw6o3pe8=";
        "7.0" = "sha256-aix46KUQq7YOtilNpwUW7aHtG3K1MxT1vCGF6dHB2V4=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.0" = "sha256-bq0ta1pYMI7y+lxZMlBnB2ug/m3W4bNlnEPG+jvt/78=";
        "7.4" = "sha256-sVqjVQl6YRSUnw4sFf3hkrsrEO05/iydVwu5FAVjJl4=";
        "7.3" = "sha256-+d3sVGyfrnXDYWujEFpfzYZW6d3zNDWvloUCaZLdpHM=";
        "7.2" = "sha256-4yOTaWVnqwqCtnyjXQ8HFTTNIFdVvIxyoevWAjwBSfI=";
        "7.1" = "sha256-S2knXTVdPSPceNYu1GpdcvdRTdesGRhMDB3+01nYEE0=";
        "7.0" = "sha256-Wbg7znNLQE8+C7VYRN7AyAMJHtfbnOdbsenTZAp96KM=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.0" = "sha256-LUgVmsUpMy4vt2Jv0/t8hrGKsIcyB5Dc058k1qihAN4=";
        "7.4" = "sha256-i8RlRpLUC2l+m+8AcncWWHPSyakP02s3pTveEHNdsCI=";
        "7.3" = "sha256-dgQcS7YMk1xbMy3DSgC11WBgNWHfXh1odrE5A0YQY7w=";
        "7.2" = "sha256-nSthmVtxbpO/pn+nFCuJ9Ncoec7apTPtMnIFh8TiQOg=";
        "7.1" = "sha256-ky5Zg/zFyEwjHXxa+kcySzqPPwjAILRL+2GX1CdFs8s=";
        "7.0" = "sha256-wTKM5zXhTS6um2EaIGO5ea0J+dFWXOX/sIqAOcu22yw=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.0" = "sha256-gfdn7oMdpzXVqSgOiczTXTObiGsRb9LnV1Orthnp5iw=";
        "7.4" = "sha256-t1yPoZFlUmGpI/nIDC4dHTHXnBfZjjJD4N4B8Pj4jjQ=";
        "7.3" = "sha256-SLrkqiECJzLYeXhQQfwqlOiDVATbsH2dVFoUL+K0u4w=";
        "7.2" = "sha256-boZ9BwldsWUEUuXBgyC++JKvPfPx3LJysEo5y8e9SAg=";
        # "7.1" = ""; # Not supported
        # "7.0" = ""; # Not supported
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.0" = "sha256-oribKvVNHCH0xULwFPX/aNIKOACdRQDV5W+vk7z/32Q=";
        "7.4" = "sha256-77GKjMt0CUZbJa8G01sswhtX5lfdthJ5XrzOM0S3feM=";
        "7.3" = "sha256-Wk253WRciZGXDrVsEhR97D+n0Z2txh+ZST8UpWMAwcM=";
        "7.2" = "sha256-ftePatTbxglB7NRoqvF3y46ZLrIlBQRfeOkART1okR0=";
        "7.1" = "sha256-NTD5XRvsxdvezHxm/XOX2edsF6ToHhoTIk8LLNmgHq0=";
        "7.0" = "sha256-VSQuNQDWSwHgb6xedKwWWJay18zv6YClLrOxxQSMZZ8=";
      };
    };
  };

  makeSource = { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    assert !isLinux -> (phpMajor != null);
    pkgs.fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor} or (throw "php.extensions.blackfire unsupported on PHP ${phpMajor} on ${system}");
    };
in
prev.extensions.blackfire.overrideAttrs (attrs: {
  inherit version;

  src = makeSource {
    system = stdenv.hostPlatform.system;
    phpMajor = pkgs.lib.versions.majorMinor prev.php.version;
  };
})
