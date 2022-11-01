{ lib, writeShellApplication, substituteAll, stdenvNoCC, snowfallorg, ... }:

let
  bool-to-string = value: if value then "true" else "false";
  patched-script = substituteAll {
    src = ./get-registry-flakes.sh;
  };
in
writeShellApplication {
  name = "get-registry-flakes";
  text = builtins.readFile patched-script;
  checkPhase = "";
  runtimeInputs = [ ];
}
