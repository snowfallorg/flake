# Snowfall Flake

<a href="https://nixos.wiki/wiki/Flakes" target="_blank">
	<img alt="Nix Flakes Ready" src="https://img.shields.io/static/v1?logo=nixos&logoColor=d8dee9&label=Nix%20Flakes&labelColor=5e81ac&message=Ready&color=d8dee9&style=for-the-badge">
</a>
<a href="https://github.com/snowfallorg/lib" target="_blank">
	<img alt="Built With Snowfall" src="https://img.shields.io/static/v1?label=Built%20With&labelColor=5e81ac&message=Snowfall&color=d8dee9&style=for-the-badge">
</a>

<p>
<!--
	This paragraph is not empty, it contains an em space (UTF-8 8195) on the next line in order
	to create a gap in the page.
-->
  
</p>

> Simplified Nix Flakes on the command line.

## Installation

### Nix Profile

You can install this package imperatively with the following command.

```bash
nix profile install github:snowfallorg/flake
```

### Nix Configuration

You can install this package by adding it as an input to your Nix Flake.

```bash
{
	description = "My system flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
		unstable.url = "github:nixos/nixpkgs/nixos-unstable";

		# Snowfall Lib is not required, but will make configuration easier for you.
		snowfall-lib = {
			url = "github:snowfallorg/lib";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		snowfall-flake = {
			url = "github:snowfallorg/flake";
			# Frost requires some packages that aren't on 22.05, but are available on unstable.
			inputs.nixpkgs.follows = "unstable";
		};
	};

	outputs = inputs:
		inputs.snowfall-lib.mkFlake {
			inherit inputs;
			src = ./.;

			overlays = with inputs; [
				# Use the overlay provided by this flake.
				snowfall-flake.overlay

				# There is also a named overlay, though the output is the same.
				snowfall-flake.overlays."nixpkgs/flake"
			];
		};
}
```

If you've added the overlay from this flake, then in your system configuration you
can add the `snowfallorg.flake` package.

```nix
{ pkgs }:

{
	environment.systemPackages = with pkgs; [
		snowfallorg.flake
	];
}
```

## Usage

### `flake new`

Create new projects from flake templates.

```bash
# Create a new flake and directory my-project with the default template.
flake new my-project

# Create a new flake and directory my-project with a custom template.
flake new my-project --template github:snowfallorg/templates#package

# Create a new flake and directory my-project with a template selected from a list.
flake new my-project --pick
```

### `flake init`

Initialize a flake in an existing project.

```bash
# Create a new flake in the current directory with the default template.
flake init

# Create a new flake in the current directory with a custom template.
flake init --template github:snowfallorg/templates#package

# Create a new flake in the current directory with a template selected from a list.
flake init --pick
```

### `flake dev`

Run development shells.

```bash
# Open the default development shell of the flake in the current directory.
flake dev

# Open a specific development shell of the flake in the current directory.
flake dev my-shell

# Open a development shell from a specific flake.
flake dev github:snowfall/dotbox#dotbox

# Pick a development shell from the current directory.
flake dev --pick

# Pick a development shell from a specific flake.
flake dev github:snowfall/dotbox --pick
```

### `flake run`

Run apps from Nix Flakes.

```bash
# Run the default app of the flake in the current directory.
flake run

# Run a specific app of the flake in the current directory.
flake run my-package

# Run a specific app from a specific flake.
flake run github:snowfall/dotbox#dotbox

# Pick an app to run from the current directory.
flake run --pick

# Pick an app to run from a specific flake.
flake run github:snowfall/dotbox --pick
```

### `flake build`

Build packages from Nix Flakes.

```bash
# Build the default package of the flake in the current directory.
flake build

# Build a specific package of the flake in the current directory.
flake build my-package

# Build a package from a specific flake.
flake build github:snowfall/dotbox#dotbox

# Pick a package to build from the current directory.
flake build --pick

# Pick a package to build from a specific flake.
flake build github:snowfall/dotbox --pick
```

### `flake switch`

Rebuild and switch system configuration with support for both NixOS and nix-darwin.

```bash
# Switch to configuration with the same hostname from the flake in the current directory.
flake switch

# Switch to specific configuration from the flake in the current directory.
flake switch my-system

# Pick a configuration to switch to from the flake in the current directory.
flake switch --pick

# Switch to configuration from a specific flake.
flake switch github:jakehamilton/config#bismuth

# Pick configuration from a specific flake.
flake switch github:jakehamilton/config --pick
```

### `flake update`

Update a Nix Flake's inputs.

```bash
# Update all flake inputs.
flake update

# Update one or more specific inputs.
flake update nixpkgs snowfall-lib

# Pick inputs to update from a list.
flake update --pick
```

### `flake build-<target>`

Build a NixOS, nix-darwin, and other types of systems.

> See `flake build-system --help` for more information.

```bash
# Build the system with the same hostname from the flake in the current directory.
flake build-system

# Build the NixOS system with the same hostname from the flake in the current directory.
flake build-nixos

# Build a specific nix-darwin system from the flake in the current directory.
flake build-darwin my-system

# Build the system with the same hostname from a specific flake.
flake build-system github:jakehamilton/config#bismuth

# Pick and build a system from the flake in the current directory
flake build-system --pick

# Pick and build a system from a specific flake.
flake build-system github:jakehamilton/config --pick

# Build a specific ISO from the flake in the current directory.
flake build-iso my-iso-system
```
