target=$1
shift

# Usage: split <string> <delimiter>
split() {
	IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
	printf '%s\n' "${arr[@]}"
}

filter_flakes() {
	local flakes=()
	while [[ $# > 0 ]]; do
		# @NOTE(jakehamilton): Some flakes like github:nix-community/emacs-overlay do not
		# provide lock files. This causes `nix eval` to error out as it can't write a new
		# lock file. Instead, we'll ignore this item and move on to others that play nicely.
		set +e

		# @NOTE(jakehamilton): We redirect stderr to /dev/null due to Nix complaining about
		# lock files on some flakes. The `nix eval` command does not provide a way to resolve
		# this, so we have to ignore errors here unfortunately.
		local has_template=$(nix eval --impure --raw --expr "\
			let
				flake = builtins.getFlake \"$1\";
				outputNames = builtins.attrNames flake.\"$target\";
				totalOutputs = builtins.length outputNames;
			in
			if flake ? \"$target\" && totalOutputs != 0 then
				\"true\"
			else
				\"false\"
		" 2>/dev/null)

		if [[ "$has_template" == true ]]; then
			flakes+=("$1")
		fi

		set -e

		shift
	done

	echo "${flakes[*]}"
}

echo "$(filter_flakes $(split "$@" " "))"
