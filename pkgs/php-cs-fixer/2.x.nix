{
  mkDerivation,
  fetchurl,
  makeWrapper,
  lib,
  php,
}:

mkDerivation rec {
  pname = "php-cs-fixer";
  version = "2.19.0";

  src = fetchurl {
    url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
    sha256 = "sha256-3K91VkeaHPx+zhGiA8QkfWH6voblCbDilTkRH2uCAYw=";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D $src $out/libexec/php-cs-fixer/php-cs-fixer.phar
    makeWrapper ${php}/bin/php $out/bin/php-cs-fixer \
      --add-flags "$out/libexec/php-cs-fixer/php-cs-fixer.phar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool to automatically fix PHP coding standards issues";
    license = licenses.mit;
    homepage = "http://cs.sensiolabs.org/";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
