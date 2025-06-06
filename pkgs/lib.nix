# SPDX-FileCopyrightText: 2023 Jan Tojnar <jtojnar@gmail.com>
# SPDX-License-Identifier: MIT

{
  lib,
}:

{
  /*
    Remove given lines from a string.

    Will fail loudly if any of the lines is not present.

    Type: removeLines :: [string] -> string -> string

    Complexity: O(|lines| × |string|)
  */
  removeLines =
    lines: string:

    let
      lineRegexp = line: "(.*)(^|\n)" + lib.escapeRegex line + "($|\n)(.*)";
      isLinePresent = line: haystack: builtins.match (lineRegexp line) haystack != null;
      lineAssertion =
        line: haystack:
        lib.assertMsg (isLinePresent line haystack) (
          "Unable to remove line “" + line + "”, it is not present in “" + haystack + "”."
        );
      removeLine =
        string: line:

        let
          result = builtins.match (lineRegexp line) string;
          linesBefore = builtins.elemAt result 0;
          separatorBefore = builtins.elemAt result 1;
          separatorAfter = builtins.elemAt result 2;
          linesAfter = builtins.elemAt result 3;
        in
        linesBefore + (if separatorBefore != "" then separatorBefore else separatorAfter) + linesAfter;
    in

    assert builtins.all (line: lineAssertion line string) lines;

    lib.foldl removeLine string lines;

  /*
    Produces a modified `env` from an old `attrs` and a attrset of list of env var values.

    The lists will be concatenated with spaces.

    Type: mergeEnv :: drvAttrs -> attrSet<envName, array<string>> -> attrSet<envName, string>
  */
  mergeEnv =
    attrs: extraEnvs:

    let
      oldEnv = attrs.env or { };

      appendEnvVar =
        name: value:
        let
          oldVal = oldEnv.${name} or "";
          sep = lib.optionalString (oldVal != "") " ";
          stringifiedNewVals = lib.concatStringsSep " " value;
        in
        "${oldVal}${sep}${stringifiedNewVals}";

      applicableExtraEnvs = lib.filterAttrs (_name: value: value != [ ]) extraEnvs;

      extraEnvsConcatenated = lib.mapAttrs appendEnvVar applicableExtraEnvs;
    in
    oldEnv // extraEnvsConcatenated;
}
