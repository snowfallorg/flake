{
  description = "Snowfall Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    flake-compat = {
      url = "github:edolstra/flake-compat?ref=v1.0.1";
      flake = false;
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib?ref=v3.0.0";
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
