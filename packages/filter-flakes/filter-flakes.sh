target=$1
shift

# Usage: split <string> <delimiter>
split() {
	IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
	printf '%s\n' "${arr[@]}"
}

result=$(echo "$(split "$@" " ")" | xargs -P 10 -I {} bash -c "filter-flake ${target} {}")

echo "$result"
