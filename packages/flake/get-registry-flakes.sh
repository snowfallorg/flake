# Usage: split <string> <delimiter>
split() {
	IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
	printf '%s\n' "${arr[@]}"
}

full_output=$(nix registry list)

global_flakes=()

while IFS= read -r line; do
	parts=($(split "$line" " "))

	type=${parts[0]}
	registry_uri=${parts[1]}
	flake_uri=${parts[2]}

	if [[ "$type" != "system" && "$flake_uri" != path:/nix/store*  ]]; then
		global_flakes+=("${flake_uri}")
	fi
done <<< "$full_output"

echo "${global_flakes[*]}"
