{
  stdenv,
  lib,
  fetchurl,
  aspell,
  pkg-config,
  glib,
  hunspell,
  hspell
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "enchant";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/AbiWord/enchant/releases/download/enchant-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}/enchant-${finalAttrs.version}.tar.gz";
    hash = "sha256-vvDZwP7y5Oh0aVa2jk1sZkH2uFvSkI2Rcx77aOup4/U=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aspell
    glib
    hunspell
    hspell
  ];

  patches = [
    # This patch prevent libtool to fail with the following error:
    # > libtool: link: unable to infer tagged configuration
    # > libtool:   error: specify a tag with '--tag'
    # Report and fix from https://bugs.gentoo.org/630072
    ./fix-libtool-build.patch
  ];

  meta = {
    description = "Generic spell checking library";
    homepage = "https://abiword.github.io/enchant";
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.unix;
  };
})
