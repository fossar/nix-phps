{ prev, mkPhp, ... }:

let
  archives = [
    { version = "7.2.0"; rev = "php-7.2.0"; hash = "sha256-K/765CJrm5eHnJ0zB45QvbXBf0X/biVZUQYqUpcgxko="; }
    { version = "7.2.1"; rev = "php-7.2.1"; hash = "sha256-/gZ5PyaKTdKcvF9O9BXwHnhodxUrAiIa19GNu2hk63k="; }
    { version = "7.2.2"; rev = "php-7.2.2"; hash = "sha256-+EGsWOF0cfIkHqiSs07bAdybk62fZh/+Tj8fR2qPSu4="; }
    { version = "7.2.3"; rev = "php-7.2.3"; hash = "sha256-SnNarAunZN2CCOopAH05FjlsUpLgA7qNO+xJ7c3Vv5I="; }
    { version = "7.2.4"; rev = "php-7.2.4"; hash = "sha256-EWWKDXZNyUAjuftg1LXrddQ4rReYHv5wq7DQ0JpEfvM="; }
    { version = "7.2.5"; rev = "php-7.2.5"; hash = "sha256-84IO+o76eWKLbhtbL4wbBMCNMuZyH6FlQDnOX4l5YDE="; }
    { version = "7.2.6"; rev = "php-7.2.6"; hash = "sha256-rl0+itqAudKT0Mi9ZD0HwtmIU4/xBSo/cUTGsM0P8sM="; }
    { version = "7.2.7"; rev = "php-7.2.7"; hash = "sha256-zIFnWpavTdGNj/wC8mo2xiKrrfhq9+z+p7zejTyW1aM="; }
    { version = "7.2.8"; rev = "php-7.2.8"; hash = "sha256-H4Bo9SCmD/89sZvhuEnwwCozoP2LNLeuBVVu9oIYfuY="; }
    { version = "7.2.9"; rev = "php-7.2.9"; hash = "sha256-6eOqpsMXt/6ngkanWLAXVENmBJ0nia1aRP6TmEZMU6g="; }
    { version = "7.2.10"; rev = "php-7.2.10"; hash = "sha256-AbYSmgkhoWNrB9qbxZiodmaeRaRizvS1hE/CaGLb2p0="; }
    { version = "7.2.11"; rev = "php-7.2.11"; hash = "sha256-Sg1/QC0Hlms3pgB5YoP0ykB52VXZbVvsAk3QIAnYtMU="; }
    { version = "7.2.12"; rev = "php-7.2.12"; hash = "sha256-tyTEwgNHthBb4QnZjMOVphAXToqttQbILoy2RbZe9rY="; }
    { version = "7.2.13"; rev = "php-7.2.13"; hash = "sha256-W0pG+3ZJG80+7hITdzOC5XD27PmyLWI7JOKCIpiz6S0="; }
    { version = "7.2.14"; rev = "php-7.2.14"; hash = "sha256-9WEy0kjHvx4O/IpoCktZjW/3P8a5yEtde1Oa2Nt6ZZc="; }
    { version = "7.2.15"; rev = "php-7.2.15"; hash = "sha256-yT52FpRqRjkRgYx+n54hJ2x3k/uMfLFYdxiN0FRtBVQ="; }
    { version = "7.2.16"; rev = "php-7.2.16"; hash = "sha256-LArRAFPVhpTNFDIySOzW2bpx0nM9Fglzw1atAdCefzg="; }
    { version = "7.2.17"; rev = "php-7.2.17"; hash = "sha256-kagRq29tessxIVnPawo8/+loZ2/evwQuklMkXMYJT3U="; }
    { version = "7.2.18"; rev = "php-7.2.18"; hash = "sha256-+honsS0RcyB+geeYpI1Kf3e6iX9cUgCsC11iqotMS3I="; }
    { version = "7.2.19"; rev = "php-7.2.19"; hash = "sha256-69Cx83X+B+1JJazCE9L173amG9XeF057ZmuYQhqQoJk="; }
    { version = "7.2.20"; rev = "php-7.2.20"; hash = "sha256-n7gp5U5UxIOuiJLR2w99eRFcxpjy81kail5Y2UENyoQ="; }
    { version = "7.2.21"; rev = "php-7.2.21"; hash = "sha256-NDGDob6DNmcBcYhcdh1X/8rpnLvPHbQ9p8tVZQVrFO8="; }
    { version = "7.2.22"; rev = "php-7.2.22"; hash = "sha256-wQqYg7WGraXvEUnyVxYlsn79zD5woE+7kSGXljOw8Io="; }
    { version = "7.2.23"; rev = "php-7.2.23"; hash = "sha256-oXrzZD0p1+cw+Xfjd23D4yXVygCzYeQdv8I2jrrVQw0="; }
    { version = "7.2.24"; rev = "php-7.2.24"; hash = "sha256-oHmTTbYwaLvMm70ue5FrmJH8l3GYYml+X5VMY5mE9gM="; }
    { version = "7.2.25"; rev = "php-7.2.25"; hash = "sha256-fLM2se0PnYf0a7y3s0N+4lLQ1QYMD7Gpha22y8c6a54="; }
    { version = "7.2.26"; rev = "php-7.2.26"; hash = "sha256-822G7s9X/5Gdb2ewZOH0GZP2LjmR6keWA42NmcdOhHs="; }
    { version = "7.2.27"; rev = "php-7.2.27"; hash = "sha256-W8BpWxcbhwzrCDxUMsanWNPb04MKDPbPNb2bKDpicEk="; }
    { version = "7.2.28"; rev = "php-7.2.28"; hash = "sha256-fJU6W3nbPY1FxlAUrvOCpI4cNDXPDCV06UKVfwzdUqM="; }
    { version = "7.2.29"; rev = "php-7.2.29"; hash = "sha256-6qH1UD8r8MhWnsSugP/Yyoy8Jg8BwlA90Og9/JzwuSM="; }
    { version = "7.2.30"; rev = "php-7.2.30"; hash = "sha256-xM9cnevo/Y3vCpMyMc8vo6i90iVVrlfoJb+saoenEr8="; }
    { version = "7.2.31"; rev = "php-7.2.31"; hash = "sha256-G6dVl0XXBPOXZKXesALrlPXLjZqqIZprizK5QXTopwA="; }
    { version = "7.2.32"; rev = "php-7.2.32"; hash = "sha256-cVwKQnStF85EnNDxa4p0KJNuO6gAAtCUioaZpvddmKc="; }
    { version = "7.2.33"; rev = "php-7.2.33"; hash = "sha256-A92jo6DIvvybOBvJz0Y40ThieD/HuK70P91EMauFhU0="; }
    { version = "7.2.34"; rev = "php-7.2.34"; hash = "sha256-DlgW1miiuxSspozvjEMEML2Gw8UjP2xCfRpUqsEnq88="; }
  ];

  phps = builtins.foldl'
    (acc: item: acc // {
      "php${builtins.replaceStrings [ "." "-" ] [ "" "" ] item.version}" = (mkPhp { version = item.version; hash = item.hash; }).withExtensions
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
            sodium
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
