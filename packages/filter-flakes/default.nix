{ lib, writeShellApplication, gum, glow, substituteAll, stdenvNoCC, snowfallorg, ... }:

let
  bool-to-string = value: if value then "true" else "false";
  patched-script = substituteAll {
    src = ./filter-flakes.sh;
  };
in
writeShellApplication {
  name = "filter-flakes";
  text = builtins.readFile patched-script;
  checkPhase = "";
  runtimeInputs = [ ];
}
