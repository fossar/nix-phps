{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  autoreconfHook,
  findXMLCatalogs,
  libiconv,
  icuSupport ? false,
  icu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxml2";
  version = "2.12.9";

  outputs = [
    "bin"
    "dev"
    "out"
  ];
  outputMan = "bin";

  src = fetchurl {
    url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor finalAttrs.version}/libxml2-${finalAttrs.version}.tar.xz";
    hash = "sha256-WZEttTarVqOZZInqApl2jHvP/lcWnwI15/liqR9INZA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  propagatedBuildInputs =
    [
      findXMLCatalogs
    ]
    ++ lib.optionals stdenv.isDarwin [ libiconv ]
    ++ lib.optionals icuSupport [ icu ];

  configureFlags = [
    "--exec-prefix=${placeholder "dev"}"
    (lib.withFeature icuSupport "icu")
    "--without-python"
  ];

  enableParallelBuilding = true;

  doCheck = (stdenv.hostPlatform == stdenv.buildPlatform) && stdenv.hostPlatform.libc != "musl";
  preCheck = lib.optional stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH="$PWD/.libs:$DYLD_LIBRARY_PATH"
  '';

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  postFixup = ''
    moveToOutput bin/xml2-config "$dev"
    moveToOutput lib/xml2Conf.sh "$dev"
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libxml2";
    description = "XML parsing library for C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
      eelco
      jtojnar
    ];
    pkgConfigModules = [ "libxml-2.0" ];
  };
})
