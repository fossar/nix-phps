{ prev, mkPhp, packageOverrides, ... }:

let
  archives = [
    { version = "8.1.0"; hash = "sha256-ByXtK66hJUlqiYRV1QGndGAhiyoM+tdz+pMi9JG4K2E="; inherit packageOverrides; }
    { version = "8.1.1"; hash = "sha256-j4vJytbNEk7cER99sKEJdF4vY4dwoQGzwiopU/eptA4="; inherit packageOverrides; }
    { version = "8.1.2"; hash = "sha256-kT3H3UOIQn+jPqSsiYNOhW/1OU9CGOrOJgo6J59bU6k="; inherit packageOverrides; }
    { version = "8.1.3"; hash = "sha256-NUxOLFBgRuyoEtH8JSaISi9UtePSDvDt6RmmnrIy0L4="; inherit packageOverrides; }
    { version = "8.1.4"; hash = "sha256-s/aIy2l1hSODi45/UJqu8BUhM9m4SoSgt89o7q/B33Y="; inherit packageOverrides; }
    { version = "8.1.5"; hash = "sha256-gn3lZ3HDq4MToGmBLxX27EmYnVEK69Dc4YCDnG2Nb/M="; inherit packageOverrides; }
    { version = "8.1.6"; hash = "sha256-ezUzBLdAdVT3DT4QGiJqH8It7K5cTELtJwxOOJv6G2Y="; inherit packageOverrides; }
    { version = "8.1.7"; hash = "sha256-uBZ1PrAFUR5pXZCUXCcJPDI2zHPbEmJlbZ+t1z6tfp0="; inherit packageOverrides; }
    { version = "8.1.8"; hash = "sha256-uIFaWgJDFFPUJh41mL0fKFFuTANU8yjBKJDyV4cOTAE="; inherit packageOverrides; }
    { version = "8.1.9"; hash = "sha256-nrsOLlcdtv1ZMEKNyy0Z7T4FAzjsHxNHwoLK6S/Ahv8="; inherit packageOverrides; }
    { version = "8.1.10"; hash = "sha256-LejgQCKF98Voh97+ZRkiMIre1YumC+/PO3dyAgnjHxA="; inherit packageOverrides; }
    { version = "8.1.11"; hash = "sha256-r2JQsYtEA7bu/5tKAnhqyGoSoggUH29lR495JW9H8kY="; inherit packageOverrides; }
    { version = "8.1.12"; hash = "sha256-+H1z6Rf6z3jee83lP8L6pNTb4Eh6lAbhq2jIro8z6wM="; inherit packageOverrides; }
    { version = "8.1.13"; hash = "sha256-k/z9+qo9CUoP2xjOCNIPINUm7j8HoUaoqOyCzgCyN8o="; inherit packageOverrides; }
    { version = "8.1.14"; hash = "sha256-FMqZMz3WBKUEojaJRkhaw103nE2pbSjcUV1+tQLf+jI="; inherit packageOverrides; }
    { version = "8.1.15"; hash = "sha256-GNoKlCKPQgf4uePiPogfK3TQ1srvuQi9tYY9SgEDXMY="; inherit packageOverrides; }
    { version = "8.1.16"; hash = "sha256-zZ8OoU2C2UVVh6SaC2yAKnuNj/eXA/n0ixfbAQ+2M84="; inherit packageOverrides; }
    { version = "8.1.17"; hash = "sha256-9Pspig6wkflE7OusV7dtqudoqXDC9RYQpask802MDK8="; inherit packageOverrides; }
    { version = "8.1.18"; hash = "sha256-0qww1rV0/KWU/gzAHAaT4jWFsnRD40KwqrBydM3kQW4="; inherit packageOverrides; }
    { version = "8.1.19"; hash = "sha256-ZCByB/2jC+kmou8fZv8ma/H9x+AzObyZ+7oKEkXkJ5s="; inherit packageOverrides; }
    { version = "8.1.20"; hash = "sha256-VVeFh1FKJwdQD4UxnlfA1N+biAPNsmVmWVrEv0WdxN0="; inherit packageOverrides; }
    { version = "8.1.21"; hash = "sha256-bqSegzXWMhd/VrUHFgqhUcewIBhXianBSFn85dSgd20="; inherit packageOverrides; }
    { version = "8.1.22"; hash = "sha256-mSNU44LGxhjQHtS+Br7qjewxeLFBU99k08jEi4Xp+8I="; inherit packageOverrides; }
    { version = "8.1.23"; hash = "sha256-kppieFF32okt3/ygdLqy8f9XhHOg1K25FcEvXz407Bs="; inherit packageOverrides; }
  ];

  makeSrc = item: {
    src = prev.fetchurl {
      url = "https://www.php.net/distributions/php-${item.version}.tar.bz2";
      inherit (item) hash;
    };
  };

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = prev.php81.override { inherit packageOverrides; phpAttrsOverrides = attrs: ((builtins.removeAttrs item [ "packageOverrides" ]) // makeSrc item); };
    })
    { }
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
