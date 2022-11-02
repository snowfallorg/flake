{ lib, writeShellApplication, gum, substituteAll, stdenvNoCC, ... }:

let
  substitute = args: builtins.readFile (substituteAll args);

  filter-flake = writeShellApplication {
    name = "filter-flake";
    text = builtins.readFile ./filter-flake.sh;
    checkPhase = "";
  };
  filter-flakes = writeShellApplication {
    name = "filter-flakes";
    text = builtins.readFile ./filter-flakes.sh;
    checkPhase = "";
    runtimeInputs = [
      filter-flake
    ];
  };
  get-registry-flakes = writeShellApplication {
    name = "get-registry-flakes";
    text = builtins.readFile ./get-registry-flakes.sh;
    checkPhase = "";
  };
in
writeShellApplication {
  name = "flake";
  text = substitute {
    src = ./flake.sh;

    inherit (stdenvNoCC) isDarwin;
    help = ./help;
  };
  checkPhase = "";
  runtimeInputs = [
    gum
    filter-flakes
    get-registry-flakes
  ];
}
