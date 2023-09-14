{
  description = "Snowfall Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      snowfall = {
        namespace = "snowfallorg";
      };

      alias.packages.default = "flake";
    };
}
