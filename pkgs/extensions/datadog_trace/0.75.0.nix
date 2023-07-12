{ buildPecl, curl, lib, pcre2 }:

buildPecl {
  pname = "datadog_trace";
  version = "0.75.0";
  sha256 = "sha256-xgymzG9QBhLO/sBaEAfAVwPDB8PswB5Yq6yqXbyvAvw=";

  buildInputs = [
    curl
    pcre2
  ];

  meta = {
    description = "Datadog Tracing PHP Client";
    homepage = "https://github.com/DataDog/dd-trace-php";
    license = with lib.licenses; [ asl20 bsd3 ];
    maintainers = lib.teams.php.members;
  };
}
