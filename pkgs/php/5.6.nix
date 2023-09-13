{ prev, mkPhp, ... }:

let
  archives = [
    { version = "5.6.0"; hash = "sha256-CXrxvjT8c5Zeb4QB/RDnPrVuGWntT/1pH7fpFgbQ/Ak="; }
    { version = "5.6.1"; hash = "sha256-gsHM0Xgw1pfXpNdbtg6hK+WPqAtNuhAel9saY3LKRfA="; }
    { version = "5.6.2"; hash = "sha256-Zx3PH2NkEMY7uesBXEwYDZBPVDb4Ehe+Ctv1Lam+zbU="; }
    { version = "5.6.3"; hash = "sha256-iYayASTRRDDXlRZeR4Ae8GWjjVhVvqOdDUexOrmtQAk="; }
    { version = "5.6.4"; hash = "sha256-V2+QAbYS9d3CL0RzEbvsMh4slZtqUiWdZkxLoE7wRPE="; }
    { version = "5.6.5"; hash = "sha256-ratMB3VRKlygrnTgjv3JQdklKbdSg+D0TT9Tgizf0G0="; }
    { version = "5.6.6"; hash = "sha256-CWJcm2XgyBmNx2mVo18P7sDhPqRIlSbmSgCVSxKtu0w="; }
    { version = "5.6.7"; hash = "sha256-ApVPt0xhp4edSOvc1Oy3iqAFb0IVypsJYjLeKOuPF7w="; }
    { version = "5.6.8"; hash = "sha256-CvAEV0XWHut0o+p0RSmiSBsny2idpyDmwCUGdQQ3JOQ="; }
    { version = "5.6.9"; hash = "sha256-GdO4e3uLujviTPbXV9FrcjqYiBw6+NFUaf0lUB6avLk="; }
    { version = "5.6.10"; hash = "sha256-Clecgcck6kGBXu4Mqo6n2O6zAkWFGdjMT8WwVVd8jEU="; }
    { version = "5.6.11"; hash = "sha256-vWsmCBZ2TCZyRHSerQdIISDb+NGSDru7DcsqpBEDOGY="; }
    { version = "5.6.12"; hash = "sha256-bycQQnKveyqZb4XkEA+sYnYw+9rznXvSY/Fs9SnIhTo="; }
    { version = "5.6.13"; hash = "sha256-Y1iDfJy6tBuR7eWdvwZwrg+5JaE2nsvBpEonISQg+JM="; }
    { version = "5.6.14"; hash = "sha256-NvKV8RZBwYOaXfAOaT9oX9E0xl6KHUbo7gq66GYrLrA="; }
    { version = "5.6.15"; hash = "sha256-EaBkXE1LdJ4lbaHg1t+J3YhrWwa4PJFNlCZTZh29HDg="; }
    { version = "5.6.16"; hash = "sha256-T+b0CWTBv6ugX8FEuiCiza0z4RaF9PEB6lpIuYu80q4="; }
    { version = "5.6.17"; hash = "sha256-d7RfVqHmPnW7IrQs+4tDjsQIPFnOd0tNfBaFVEt63Ts="; }
    { version = "5.6.18"; hash = "sha256-w81KKalWIwnTbisShAfW6qXH3eWQ0rGkZEVzg+UX9O0="; }
    { version = "5.6.19"; hash = "sha256-KiSj+ElxaArApMcQUAZ95Pdu4jWqSgQfriG/ppl1wWg="; }
    { version = "5.6.20"; hash = "sha256-Wse/fK7Hp5sYz0WOeG/RYJrS2ncSJLgLwVzG8Bsivx8="; }
    { version = "5.6.21"; hash = "sha256-tO16tXS2if1tZJT96VSCbAbvyFxQXgF7jXdsfH9HlZA="; }
    { version = "5.6.22"; hash = "sha256-kNqKgMxS+mmc8r+kxvpzfHct98krge9INGCqOx6fiMY="; }
    { version = "5.6.23"; hash = "sha256-+s0oCJbSd+b3CEtgg55pPU22gxi/ySCF09wCUf01WMc="; }
    { version = "5.6.24"; hash = "sha256-vyNhfsPtChJeyL3it7yp04BLL/TfjeGSiQyE3J+sOMY="; }
    { version = "5.6.25"; hash = "sha256-WM5gMqztfz5CztSSvZgg5bPyo80+9xQpqpL9ez6xjd4="; }
    { version = "5.6.26"; hash = "sha256-1HqrgIOkKEuQV3fhtF3Xc1rcU76Ceyn4lmhHUKyLYjY="; }
    { version = "5.6.27"; hash = "sha256-O3fToGe26cx7soLU1bDm7rBiOoKLsEeSQeOwMERvKjw="; }
    { version = "5.6.28"; hash = "sha256-xV6j9KrVoLZWMdAcRGiTD9mBrSCP/NJCrN9zG8tHVI8="; }
    { version = "5.6.29"; hash = "sha256-SZuETIqnvgZMERaS5RoJO6lOVNLZq7AecOp2GDoYJbs="; }
    { version = "5.6.30"; hash = "sha256-oQXCk/odv/EYtbDKdAKebEYfjHj0mzN6Kpi+njLCeQY="; }
    { version = "5.6.31"; hash = "sha256-jzlxactl8FOfO8sEBg+Xdw1z4ZB0o3vSxYuY6/bssQ8="; }
    { version = "5.6.32"; hash = "sha256-PuROel+kK1Y2UrPqDTSHvCNvzJ5ep0tYN3XKuGery1E="; }
    { version = "5.6.33"; hash = "sha256-B/aWqXYdzYOeIEXJXDpNL/tSxUQXR3zKnTChSXW4Mcw="; }
    { version = "5.6.34"; hash = "sha256-4Z9JnYzuSwsHgDYey2oAxBZUdyp1SAOrnqhmuNR88s0="; }
    { version = "5.6.35"; hash = "sha256-7nin6coh2Oo5TQN8Ve//9HeknbrjHHdTxUcDb1vXO5I="; }
    { version = "5.6.36"; hash = "sha256-YmoOP12KDmhqK5MPDdOgYB/j3LXkPdDow/q2MeZOFyo="; }
    { version = "5.6.37"; hash = "sha256-iGrWPQXZTqPlQyJpGq3qDPHUvNtEULAv4wDltXB4iyM="; }
    { version = "5.6.38"; hash = "sha256-1lsjG73WO+RDnvXO2WXP1j5imDQp29Tfz7SZgVk+vAM="; }
    { version = "5.6.39"; hash = "sha256-s9sjRfUMAQsB/gQbTg9mxaoo6zJRNRNvFT4Y2gFYOtU="; }
    { version = "5.6.40"; hash = "sha256-/9Al00YjVTqy9/2Psh0Mnm+fow3FZcoDode3YwI/ugA="; }
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
