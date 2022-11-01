{ lib, writeShellApplication, gum, substituteAll, stdenvNoCC, snowfallorg, ... }:

let
  bool-to-string = value: if value then "true" else "false";
  patched-script = substituteAll {
    src = ./flake.sh;

    inherit (stdenvNoCC) isDarwin;
    help = ./help;
  };
in
writeShellApplication {
  name = "flake";
  text = builtins.readFile patched-script;
  checkPhase = "";
  runtimeInputs = [
    gum
    snowfallorg.filter-flakes
    snowfallorg.get-registry-flakes
  ];
}
