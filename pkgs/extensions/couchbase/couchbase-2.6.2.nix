{ lib
, libcouchbase
, buildPecl
, fetchFromGitHub
, substituteAll
, zlib
, prev
}:

let
  pname = "couchbase";
  version = "2.6.2";
in
buildPecl {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "php-couchbase";
    rev = "v${version}";
    hash = "sha256-Q1WSt5CsrNAvF4D0Dp1rxTBuyMOEAG3FSg+H9G31uXo=";
  };

  configureFlags = [ "--with-couchbase" ];

  buildInputs = [ libcouchbase zlib ];
  internalDeps = [ prev.php.extensions.json ];
  peclDeps = [ prev.php.extensions.igbinary ];

  patches = [
    (substituteAll {
      # Patch backported from https://github.com/NixOS/nixpkgs/blob/e76ccc6b2798e50ef959a8cf830035d76a92106b/pkgs/development/php-packages/couchbase/default.nix#L23
      src = ./0001-fix-config.m4.patch;
      inherit libcouchbase;
      igbinary = prev.php.extensions.igbinary.dev;
    })
  ];

  meta = {
    description = "Couchbase Server PHP extension";
    license = lib.licenses.asl20;
    homepage = "https://docs.couchbase.com/php-sdk/current/project-docs/sdk-release-notes.html";
    maintainers = lib.teams.php.members;
  };
}
