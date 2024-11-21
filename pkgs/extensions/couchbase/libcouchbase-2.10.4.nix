{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libevent, openssl}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcouchbase";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "libcouchbase";
    rev = finalAttrs.version;
    hash = "sha256-hy8TnRzaBO2wgeC9EVlBFg0tap1GQaYPoqVhVUxn1fk=";
  };

  cmakeFlags = [ "-DLCB_NO_MOCK=ON" ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libevent openssl ];

  patches = [
    # Patch from https://github.com/NixOS/nixpkgs/commit/fd41a333d806b9d4ac4a5f39775b650edc5756f6
    ./0001-Fix-timeouts-in-libcouchbase-testsuite.patch
    # Custom patch to fix the .pc file
    ./0001-fix-libcouchbase.pc.in.patch
  ];

  meta = {
    description = "C client library for Couchbase";
    homepage = "https://github.com/couchbase/libcouchbase";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
