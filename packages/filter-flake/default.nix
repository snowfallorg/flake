{ lib, writeShellApplication, substituteAll, stdenvNoCC, snowfallorg, ... }:

let
  bool-to-string = value: if value then "true" else "false";
  patched-script = substituteAll {
    src = ./filter-flake.sh;
  };
in
writeShellApplication {
  name = "filter-flake";
  text = builtins.readFile patched-script;
  checkPhase = "";
  runtimeInputs = [ ];
}
