{ mkDerivation, fetchurl, makeWrapper, unzip, lib, php }:
let
  pname = "composer";
  version = "2.2.22";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://getcomposer.org/download/${version}/composer.phar";
    hash = "sha256-fTUAzIyadLR+FBA94VCslcJcoiezn/yJyzqLSVtdsdI=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/composer/composer.phar
    makeWrapper ${php}/bin/php $out/bin/composer \
      --add-flags "$out/libexec/composer/composer.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Dependency Manager for PHP";
    license = licenses.mit;
    homepage = "https://getcomposer.org/";
    changelog = "https://github.com/composer/composer/releases/tag/${version}";
    maintainers = with maintainers; [ offline ] ++ teams.php.members;
  };
}
