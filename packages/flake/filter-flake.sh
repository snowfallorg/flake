# @NOTE(jakehamilton): Some flakes like github:nix-community/emacs-overlay do not
# provide lock files. This causes `nix eval` to error out as it can't write a new
# lock file. Instead, we'll ignore this item and move on to others that play nicely.
set +e

# @NOTE(jakehamilton): We redirect stderr to /dev/null due to Nix complaining about
# lock files on some flakes. The `nix eval` command does not provide a way to resolve
# this, so we have to ignore errors here unfortunately.
has_target=$(nix eval --impure --raw --expr "\
	let
		flake = builtins.getFlake \"$2\";
		outputNames = builtins.attrNames (flake.\"$1\" or {});
		totalOutputs = builtins.length outputNames;
	in
	if flake ? \"$1\" && totalOutputs != 0 then
		\"true\"
	else
		\"false\"
" 2>/dev/null)

if [[ "$has_target" == true ]]; then
	echo "$2"
fi

set -e
