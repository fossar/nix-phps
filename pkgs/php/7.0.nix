{ prev, mkPhp, ... }:

let
  archives = [
    { version = "7.0.0"; hash = "sha256-qSpUMGgyFno598DsAFJPxvP32YXIBsqnYyVh0N3t/Oo="; }
    { version = "7.0.1"; hash = "sha256-BM470doAE5ezQsIhmlCTvp7LvJfwIuHmoOwv7cPZPkI="; }
    { version = "7.0.2"; hash = "sha256-mxt1+9nJLGsAA7I05VCWUDiCbRHqH0ML8nmWTanaIjY="; }
    { version = "7.0.3"; hash = "sha256-gmgj11TwnHeSIqmb7PnFOk3HGdui13esp4B8bKaOb8Y="; }
    { version = "7.0.4"; hash = "sha256-okbFA3CcGJuo4eIu0ssiq8J9pDqZf/GzMY4YG69Sncw="; }
    { version = "7.0.5"; hash = "sha256-LAmvf+ZFN+p5XwmLm1QurUB++D983GWzeHEVzLu1Hek="; }
    { version = "7.0.6"; hash = "sha256-FN3xkqmWXIWMHnQqYUVr4vNKTbh1VhcsDXbwjeljKbc="; }
    { version = "7.0.7"; hash = "sha256-R08pJcR4K5QBbjr7sXsU/5zG9P229uIxs2o3i7GKPRo="; }
    { version = "7.0.8"; hash = "sha256-Ztx7o4hJDgexMT/joGsfqCLhMQWF/in0kJmV8THifI0="; }
    { version = "7.0.9"; hash = "sha256-LuaWi1h18vOHAMWKGJqthZpqC4X8M3qhAuwtw2UsO3s="; }
    { version = "7.0.10"; hash = "sha256-gFW75ac2mGkxwMagi3ZdbXeCcex9LVbFChrSWewJ9t4="; }
    { version = "7.0.11"; hash = "sha256-+ZtyncEUmFiESxivHowN5t0c391S4i+7TeKqeL+b9/E="; }
    { version = "7.0.12"; hash = "sha256-OMRylP6PsjmwIw3GOpPD5ARPRyq5O13/i2X+tBA6aic="; }
    { version = "7.0.13"; hash = "sha256-0JC7UjgSEX7AwI2PC1xfBhaqeimi7u4DdO/lOnz+iME="; }
    { version = "7.0.14"; hash = "sha256-+8Q2mg1CtV/RznXrTz0XsBLadUpnVn2OMoj7+7dJBTQ="; }
    { version = "7.0.15"; hash = "sha256-qMj5RzNWg/pt0bdEPtcPKkK8M+i2whXxOROM7onkfdk="; }
    { version = "7.0.16"; hash = "sha256-g8X1dXXcD+ylY69SnW8dYBg7+cLBPpim2hMfvQo1l6s="; }
    { version = "7.0.17"; hash = "sha256-ruUDkmuW2AdpL6w+D9ZOMll4j1E5gZqYMVJnnLbpHUs="; }
    { version = "7.0.18"; hash = "sha256-sgzGPVBwMrOdi7FMtkeE5GCw5HmX6QqHBLcDvLsjP9E="; }
    { version = "7.0.19"; hash = "sha256-DzrAr8Aq7CL2sWWQRdqSh0U+kwlDnQSZYivI6Up/fVk="; }
    { version = "7.0.20"; hash = "sha256-zf3f4BzGFSGOMz40ocdhye+P31GZsnYXJkoCcF7af8M="; }
    { version = "7.0.21"; hash = "sha256-K6Ezw5Leb4aqzO2MVOCt79HIHThArDI7mSa47T3GIx8="; }
    { version = "7.0.22"; hash = "sha256-iOCyf2mr3RLs3oHwAMWp6kea9yGEVup/ZVfttDxt/d4="; }
    { version = "7.0.23"; hash = "sha256-b+lM78fSxg7iwWSLl3vu11atnNCn5OqLuM9SHZNVoJw="; }
    { version = "7.0.24"; hash = "sha256-m/kZgmlPF4ghwKrwNWOiBJSHPs5pM+Lu7P128yW9zxk="; }
    { version = "7.0.25"; hash = "sha256-laJNltEmoZbhVQ45QYK0OmRgzdICbxp3vvAeQiQVzCU="; }
    { version = "7.0.26"; hash = "sha256-JZDXIveyO2qQPFoAzwTn7nKN950Qrkc+OoG6QViFCac="; }
    { version = "7.0.27"; hash = "sha256-mfolY7tMTBzen+vofP6XMkIn17S4go8uk25QcSc5QTE="; }
    { version = "7.0.28"; hash = "sha256-rlSRtGE/NxDj0J5oi6PTDTrMERLHuWqHA2Y7ipUGPH8="; }
    { version = "7.0.29"; hash = "sha256-mJFC1cX/ehFDElT5wZlSNbrWGjNkuZyWbhHgaqENP7w="; }
    { version = "7.0.30"; hash = "sha256-IT84QAwjm4+rL29Z1vTUvUY9CnW9Tt9yPdTV/qiFC1A="; }
    { version = "7.0.31"; hash = "sha256-fovXPs7W5nmhedOVcej+5sg+UchvQzOPZcLciMEQa5E="; }
    { version = "7.0.32"; hash = "sha256-VujYz5wIF4r6hmNYmAX4O9sBY079mBMZdwOOJAZkkuE="; }
    { version = "7.0.33"; hash = "sha256-STPqdCmKG6BGsCRv43cUFchN+4eDliAbVstTM6vobwc="; }
  ];

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = (mkPhp item).withExtensions
        (
          { all, ... }: with all; [
            bcmath
            calendar
            curl
            ctype
            dom
            exif
            fileinfo
            filter
            ftp
            gd
            gettext
            gmp
            iconv
            intl
            json
            ldap
            mbstring
            mysqli
            mysqlnd
            opcache
            openssl
            pcntl
            pdo
            pdo_mysql
            pdo_odbc
            pdo_pgsql
            pdo_sqlite
            pgsql
            posix
            readline
            session
            simplexml
            sockets
            soap
            sysvsem
            sqlite3
            tokenizer
            xmlreader
            xmlwriter
            zip
            zlib
          ] ++ prev.lib.optionals (!prev.stdenv.isDarwin) [
            imap
          ]
        );
    })
    { }
    archives;
in
phps // (let last = (phps."php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.last archives).version}"); in { "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] (prev.lib.versions.majorMinor last.version)}" = last; })
