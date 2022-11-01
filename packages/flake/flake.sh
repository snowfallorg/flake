#!/usr/bin/env bash

#==============================#
#           Global             #
#==============================#

DEBUG=${DEBUG:-"false"}

#==============================#
#          Injected            #
#==============================#

is_darwin="@isDarwin@"
help_root="@help@"

#==============================#
#           Logging            #
#==============================#

text_reset="\e[m"
text_bold="\e[1m"
text_dim="\e[2m"
text_italic="\e[3m"
text_underline="\e[4m"
text_blink="\e[5m"
text_highlight="\e[7m"
text_hidden="\e[8m"
text_strike="\e[9m"

text_fg_red="\e[38;5;1m"
text_fg_green="\e[38;5;2m"
text_fg_yellow="\e[38;5;3m"
text_fg_blue="\e[38;5;4m"
text_fg_magenta="\e[38;5;5m"
text_fg_cyan="\e[38;5;6m"
text_fg_white="\e[38;5;7m"
text_fg_dim="\e[38;5;8m"

text_bg_red="\e[48;5;1m"
text_bg_green="\e[48;5;2m"
text_bg_yellow="\e[48;5;3m"
text_bg_blue="\e[48;5;4m"
text_bg_magenta="\e[48;5;5m"
text_bg_cyan="\e[48;5;6m"
text_bg_white="\e[48;5;7m"
text_bg_dim="\e[48;5;8m"

# Usage: log_info <message>
log_info() {
	echo -e "${text_fg_blue}info${text_reset}  $1"
}

# Usage: log_todo <message>
log_todo() {
	echo -e "${text_bg_magenta}${text_fg_white}todo${text_reset}  $1"
}

# Usage: log_debug <message>
log_debug() {
	if [[ $DEBUG == true ]]; then
		echo -e "${text_fg_dim}debug${text_reset} $1"
	fi
}

# Usage: log_warn <message>
log_warn() {
	echo -e "${text_fg_yellow}warn${text_reset}  $1"
}

# Usage: log_error <message>
log_error() {
	echo -e "${text_fg_red}error${text_reset} $1"
}

# Usage: log_fatal <message> [exit-code]
log_fatal() {
	echo -e "${text_fg_white}${text_bg_red}fatal${text_reset} $1"

	if [ -z ${2:-} ]; then
		exit 1
	else
		exit $2
	fi
}

# Usage: clear_previous_line [number]
clear_line() {
	echo -e "\e[${1:-"1"}A\e[2K"
}

# Usage:
# 	rewrite_line <message>
# 	rewrite_line <number> <message>
rewrite_line() {
	if [[ $# == 1 ]]; then
		echo -e "\e[1A\e[2K${1}"
	else
		echo -e "\e[${1}A\e[2K${2}"
	fi
}

#==============================#
#           Options            #
#==============================#
positional_args=()

opt_help=false
opt_pick=false
opt_template=

# Usage: missing_value <option>
missing_opt_value() {
	log_fatal "Option $1 requires a value"
}

# shellcheck disable=SC2154
while [[ $# > 0 ]]; do
	case "$1" in
		-h|--help)
			opt_help=true
			shift
			;;
		-p|--pick)
			opt_pick=true
			shift
			;;
		-t|--template)
			if [ -z ${2:-} ]; then
				missing_opt_value $1
			fi

			opt_template="$2"
			shift 2
			;;
		--debug)
			DEBUG=true
			shift
			;;
		--)
			shift
			break
			;;
		-*|--*)
			echo "Unknown option $1"
			exit 1
			;;
		*)
			positional_args+=("$1")
			shift
			;;
	esac
done

passthrough_args=($@)

#==============================#
#          Helpers             #
#==============================#

# Usage: split <string> <delimiter>
split() {
	IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
	printf '%s\n' "${arr[@]}"
}

# Usage: lstrip <string> <pattern>
lstrip() {
	printf '%s\n' "${1##$2}"
}

# Usage: show_help <path>
show_help() {
	log_debug "Showing help: ${text_bold}$1${text_reset}"
	source "${help_root}/$1.sh"
}

# Usage: require_flake_nix
require_flake_nix() {
	if ! [ -f ./flake.nix ]; then
		log_fatal "This command requires a flake.nix file, but one was not found in the current directory."
	fi
}

# Usage: get_flake_outputs <output> <flake-uri>
get_flake_outputs() {
		local outputs=""

		# @NOTE(jakehamilton): Some flakes may not contain the values we're looking for. In
		# which case, we swallow errors here to keep the output clean.
		set +e
		outputs=$(nix eval --impure --raw --expr "\
			let
					flake = builtins.getFlake \"$2\";
					outputs =
						if builtins.elem \"$1\" [ \"packages\" \"devShells\" \"apps\" ] then
							builtins.attrNames (flake.\"$1\".\${builtins.currentSystem} or {})
						else
							builtins.attrNames (flake.\"$1\" or {});
					names = builtins.map (output: \"$2#\" + output) outputs;
			in
			builtins.concatStringsSep \" \" names
		" 2>/dev/null)
		set -e

		echo "$outputs"
}

# Usage: replace_each <pattern> <text> <data>
replace_each() {
	local results=()

	for item in $3; do
		if [[ "$item" == $1* ]]; then
			results+=("$2$(lstrip $item $1)")
		else
			results+=("$item")
		fi
	done

	echo "${results[*]}"
}

# Usage: privileged <command>
privileged() {
	cmd="$@"
	if command -v sudo >/dev/null; then
		log_debug "sudo $cmd"
		sudo $cmd
	elif command -v doas >/dev/null; then
		log_debug "doas $cmd"
		doas $cmd
	else
		log_warn "Could not find ${text_bold}sudo${text_reset} or ${text_bold}doas${text_reset}. Executing without privileges."
		log_debug "$cmd"
		eval "$cmd"
	fi
}

# Usage: system-rebuild [...args]
system-rebuild() {
	if [[ "$is_darwin" == true ]]; then
		cmd="darwin-rebuild $@"
		privileged $cmd
	else
		cmd="nixos-rebuild $@"
		privileged $cmd
	fi
}

#==============================#
#          Commands            #
#==============================#

flake_new() {
	if [[ $opt_help == true ]]; then
		show_help new
		exit 0
	fi

	if [[ ${#positional_args[@]} -lt 2 ]]; then
		log_fatal "${text_bold}flake new${text_reset} must be given a name."
	fi

	if [[ ${#positional_args[@]} -gt 2 ]]; then
		log_fatal "${text_bold}flake new${text_reset} received too many positional arguments."
	fi

	if [[ ${opt_pick} == true ]]; then
		local registry_flakes=($(gum spin \
			--title "Getting flakes from registry" \
			--spinner.foreground="4" \
			--show-output \
			-- get-registry-flakes \
		))

		local template_flakes=($(gum spin \
			--title "Finding templates" \
			--spinner.foreground="4" \
			--show-output \
			-- filter-flakes templates "${registry_flakes[*]}" \
		))

		log_debug "found ${#template_flakes[@]} template flakes"

		local template_choices=()

		template_choices+=($(get_flake_outputs templates "github:NixOS/templates"))
		template_choices+=($(get_flake_outputs templates "github:snowfallorg/templates"))

		for flake in ${template_flakes[*]}; do
			if [ "$flake" == "github:NixOS/templates" ] || [ "$flake" == "github:snowfallorg/templates" ]; then
				continue
			fi

			template_choices+=($(get_flake_outputs templates "$flake"))
		done

		log_debug "found ${#template_choices[@]} templates"

		log_info "Select a template:"
		local template=$(gum choose \
			--height=15 \
			--cursor.foreground="4" \
			--item.foreground="7" \
			--selected.foreground="4" \
			${template_choices[*]} \
		)

		if [[ -z ${template} ]]; then
			log_fatal "No template selected"
		fi

		rewrite_line "$(log_info "Select a template: ${text_fg_blue}${template}${text_reset}")"
		
		nix flake new "${positional_args[1]}" --template "${template}"
	else
		if [[ -z ${opt_template} ]]; then
			nix flake new "${positional_args[1]}"
		else
			nix flake new "${positional_args[1]}" --template "${opt_template}"
		fi
	fi
}

flake_init() {
	if [[ $opt_help == true ]]; then
		show_help init
		exit 0
	fi

	if [[ ${#positional_args[@]} > 1 ]]; then
		log_fatal "${text_bold}flake init${text_reset} received too many positional arguments."
	fi

	if [[ ${opt_pick} == true ]]; then
		local registry_flakes=($(gum spin \
			--title "Getting flakes from registry" \
			--spinner.foreground="4" \
			--show-output \
			-- get-registry-flakes \
		))

		local template_flakes=($(gum spin \
			--title "Finding templates" \
			--spinner.foreground="4" \
			--show-output \
			-- filter-flakes templates "${registry_flakes[*]}" \
		))

		log_debug "found ${#template_flakes[@]} template flakes"

		local template_choices=()

		template_choices+=($(get_flake_outputs templates "github:snowfallorg/templates"))
		template_choices+=($(get_flake_outputs templates "github:NixOS/templates"))

		for flake in ${template_flakes[*]}; do
			if [ "$flake" == "github:NixOS/templates" ] || [ "$flake" == "github:snowfallorg/templates" ]; then
				continue
			fi

			template_choices+=($(get_flake_outputs templates "$flake"))
		done

		log_debug "found ${#template_choices[@]} templates"

		log_info "Select a template:"
		local template=$(gum choose \
			--height=15 \
			--cursor.foreground="4" \
			--item.foreground="7" \
			--selected.foreground="4" \
			${template_choices[*]} \
		)

		if [[ -z ${template} ]]; then
			log_fatal "No template selected"
		fi

		rewrite_line "$(log_info "Select a template: ${text_fg_blue}${template}${text_reset}")"
		
		nix flake init --template "${template}"
	else
		if [[ -z ${opt_template} ]]; then
			nix flake init
		else
			nix flake init --template "${opt_template}"
		fi
	fi
}

flake_switch() {
	if [[ $opt_help == true ]]; then
		show_help switch
		exit 0
	fi

	if [[ ${#positional_args[@]} > 2 ]]; then
		log_fatal "${text_bold}flake switch${text_reset} received too many positional arguments."
	fi

	if [[ $opt_pick == true ]]; then
		local flake_uri=${positional_args[1]:-}

		if [[ -z "${flake_uri}" ]]; then
			require_flake_nix
			flake_uri="path:$(pwd)"
		fi

		if [[ "$flake_uri" != *:* ]] || [[ "$flake_uri" == *#* ]]; then
			log_fatal "${text_bold}flake build --pick${text_reset} called with invalid flake uri: $flake_uri"
		fi

		local target="nixos"

		if [[ $is_darwin == true ]]; then
			target="darwin"
		fi

		local raw_systems_choices=($(get_flake_outputs "${target}Configurations" "$flake_uri"))
		local systems_choices=($(replace_each "path:$(pwd)" "." "${raw_systems_choices[*]}"))

		if [[ ${#systems_choices[@]} == 0 ]]; then
			log_fatal "Could not find any ${target} systems in flake: ${flake_uri}"
		fi

		log_info "Select a system:"
		local system=$(gum choose \
			--height=15 \
			--cursor.foreground="4" \
			--item.foreground="7" \
			--selected.foreground="4" \
			${systems_choices[*]} \
		)

		if [[ -z ${system} ]]; then
			log_fatal "No system selected"
		fi

		rewrite_line "$(log_info "Select a system: ${text_fg_blue}${system}${text_reset}")"

		system-rebuild switch --flake "${system}"
	else
		if [[ ${#positional_args[@]} == 1 ]]; then
			require_flake_nix
			log_info "Switching system configuration to .#"
			system-rebuild switch --flake ".#"
		else
			local system_name=${positional_args[1]}

			if [[ "$system_name" == *:* ]] || [[ "$system_name" == *#* ]]; then
				log_info "Switching system configuration to ${system_name}"
				system-rebuild switch --flake $system_name
			else
				require_flake_nix
				log_info "Switching system configuration to .#${system_name}"
				system-rebuild switch --flake ".#${system_name}"
			fi
		fi
	fi
}

flake_build() {
	if [[ $opt_help == true ]]; then
		show_help build
		exit 0
	fi

	if [[ ${#positional_args[@]} > 2 ]]; then
		log_fatal "${text_bold}flake build${text_reset} received too many positional arguments."
	fi

	if [[ ${opt_pick} == true ]]; then
		local flake_uri=${positional_args[1]:-}

		if [[ -z "${flake_uri}" ]]; then
			require_flake_nix
			flake_uri="path:$(pwd)"
		fi

		if [[ "$flake_uri" != *:* ]] || [[ "$flake_uri" == *#* ]]; then
			log_fatal "${text_bold}flake build --pick${text_reset} called with invalid flake uri: $flake_uri"
		fi

		local raw_packages_choices=($(get_flake_outputs packages "$flake_uri"))
		local packages_choices=($(replace_each "path:$(pwd)" "." "${raw_packages_choices[*]}"))

		if [[ ${#packages_choices[@]} == 0 ]]; then
			log_fatal "Could not find any packages in flake: ${flake_uri}"
		fi

		log_info "Select a package:"
		local package=$(gum choose \
			--height=15 \
			--cursor.foreground="4" \
			--item.foreground="7" \
			--selected.foreground="4" \
			${packages_choices[*]} \
		)

		if [[ -z ${package} ]]; then
			log_fatal "No package selected"
		fi

		rewrite_line "$(log_info "Select a package: ${text_fg_blue}${package}${text_reset}")"

		nix build "${package}"
	else
		if [[ ${#positional_args[@]} == 1 ]]; then
			require_flake_nix
			nix build ".#"
		else
			local package_name=${positional_args[1]}

			if [[ "$package_name" == *:* ]] || [[ "$package_name" == *#* ]]; then
				nix build "$package_name"
			else
				require_flake_nix
				nix build ".#${package_name}"
			fi
		fi
	fi
}

flake_build_system() {
	if [[ $opt_help == true ]]; then
		show_help build-system
		exit 0
	fi

	if [[ ${#positional_args[@]} > 2 ]]; then
		log_fatal "${text_bold}flake ${positional_args[0]}${text_reset} received too many positional arguments."
	fi

	local target=$(lstrip "${positional_args[0]}" "build-")

	log_debug "Building target system: ${target}"

	if [[ "$target" == "system" ]]; then
		if [[ $is_darwin == true ]]; then
			target="darwin"
		else
			target="nixos"
		fi
	elif [[ "$target" == "nixos-vm" ]]; then
		target="nixos"
	fi

	if [[ ${opt_pick} == true ]]; then
		local flake_uri=${positional_args[1]:-}

		if [[ -z "${flake_uri}" ]]; then
			require_flake_nix
			flake_uri="path:$(pwd)"
		fi

		if [[ "$flake_uri" != *:* ]] || [[ "$flake_uri" == *#* ]]; then
			log_fatal "${text_bold}flake ${positional_args[0]} --pick${text_reset} called with invalid flake uri: $flake_uri"
		fi

		local raw_systems_choices=($(get_flake_outputs "${target}Configurations" "$flake_uri"))
		local systems_choices=($(replace_each "path:$(pwd)#" ".#${target}Configurations." "${raw_systems_choices[*]}"))

		if [[ ${#systems_choices[@]} == 0 ]]; then
			log_fatal "Could not find any ${target} systems in flake: ${flake_uri}"
		fi

		log_info "Select a system:"
		local system=$(gum choose \
			--height=15 \
			--cursor.foreground="4" \
			--item.foreground="7" \
			--selected.foreground="4" \
			${systems_choices[*]} \
		)

		if [[ -z ${system} ]]; then
			log_fatal "No system selected"
		fi

		rewrite_line "$(log_info "Select a system: ${text_fg_blue}${system}${text_reset}")"

		if [[ "${positional_args[0]}" == "build-nixos-vm" ]]; then
			local system_parts=()

			system_parts=($(split "$system" "nixosConfigurations."))
			system="${system_parts[0]}${system_parts[1]:-}"

			system-rebuild build-vm --flake "$system"
		elif [[ "${target}" == "nixos" ]] || [[ "${target}" == "darwin" ]]; then
			local system_parts=()

			system_parts=($(split "$system" "nixosConfigurations."))
			system="${system_parts[0]}${system_parts[1]:-}"

			system_parts=($(split "$system" "darwinConfigurations."))
			system="${system_parts[0]}${system_parts[1]:-}"

			system-rebuild build --flake "$system"
		else
			nix build "$system"
		fi
	else
		if [[ ${#positional_args[@]} == 1 ]]; then
			if [[ "${positional_args[0]}" == "build-nixos-vm" ]]; then
				require_flake_nix
				system-rebuild build-vm --flake ".#"
			elif [[ "${target}" == "nixos" ]] || [[ "${target}" == "darwin" ]]; then
				require_flake_nix
				system-rebuild build --flake ".#"
			else
				log_fatal "${text_bold}flake ${positional_args[0]}${text_reset} called without a name"
			fi
		else
			local system_name=${positional_args[1]}

			if [[ "$system_name" == *:* ]] || [[ "$system_name" == *#* ]]; then
				if [[ "${positional_args[0]}" == "build-nixos-vm" ]]; then
					system-rebuild build-vm --flake "$system_name"
				elif [[ "${target}" == "nixos" ]] || [[ "${target}" == "darwin" ]]; then
					system-rebuild build --flake "$system_name"
				else
					local output_name_parts=($(split "$system_name" "#"))
					local upstream_flake_uri=${output_name_parts[0]}
					local output_name=${output_name_parts[1]:-}

					if [[ -n ${output_name} ]]; then
						nix build "${upstream_flake_uri}#${target}Configurations.${output_name}"
					else
						log_fatal "${text_bold}flake ${positional_args[0]}${text_reset} called without a name"
					fi
				fi
			else
				if [[ "${positional_args[0]}" == "build-nixos-vm" ]]; then
					require_flake_nix
					system-rebuild build-vm --flake ".#${system_name}"
				elif [[ "${target}" == "nixos" ]] || [[ "${target}" == "darwin" ]]; then
					require_flake_nix
					system-rebuild build --flake ".#${system_name}"
				else
					require_flake_nix
					nix build ".#${target}Configurations.${system_name}"
				fi
			fi
		fi
	fi
}

flake_dev() {
	if [[ $opt_help == true ]]; then
		show_help dev
		exit 0
	fi

	if [[ ${#positional_args[@]} > 2 ]]; then
		log_fatal "${text_bold}flake build${text_reset} received too many positional arguments."
	fi

	if [[ ${opt_pick} == true ]]; then
		local flake_uri=${positional_args[1]:-}

		if [[ -z "${flake_uri}" ]]; then
			require_flake_nix
			flake_uri="path:$(pwd)"
		fi

		if [[ "$flake_uri" != *:* ]] || [[ "$flake_uri" == *#* ]]; then
			log_fatal "${text_bold}flake build --pick${text_reset} called with invalid flake uri: $flake_uri"
		fi

		local raw_shells_choices=($(get_flake_outputs devShells "$flake_uri"))
		local shells_choices=($(replace_each "path:$(pwd)" "." "${raw_shells_choices[*]}"))

		if [[ ${#shells_choices[@]} == 0 ]]; then
			log_fatal "Could not find any shells in flake: ${flake_uri}"
		fi

		log_info "Select a shell:"
		local shell=$(gum choose \
			--height=15 \
			--cursor.foreground="4" \
			--item.foreground="7" \
			--selected.foreground="4" \
			${shells_choices[*]} \
		)

		if [[ -z ${shell} ]]; then
			log_fatal "No shell selected"
		fi

		rewrite_line "$(log_info "Select a shell: ${text_fg_blue}${shell}${text_reset}")"

		nix develop "${shell}"
	else
		if [[ ${#positional_args[@]} == 1 ]]; then
			require_flake_nix
			nix develop ".#"
		else
			local shell_name=${positional_args[1]}

			if [[ "$shell_name" == *:* ]] || [[ "$shell_name" == *#* ]]; then
				nix develop "$shell_name"
			else
				require_flake_nix
				nix develop ".#${shell_name}"
			fi
		fi
	fi
}

flake_run() {
	if [[ $opt_help == true ]]; then
		show_help run
		exit 0
	fi

	if [[ ${#positional_args[@]} > 2 ]]; then
		log_fatal "${text_bold}flake build${text_reset} received too many positional arguments."
	fi

	if [[ ${opt_pick} == true ]]; then
		local flake_uri=${positional_args[1]:-}

		if [[ -z ${flake_uri} ]]; then
			require_flake_nix
			flake_uri="path:$(pwd)"
		fi

		if [[ "$flake_uri" != *:* ]] || [[ "$flake_uri" == *#* ]]; then
			log_fatal "${text_bold}flake build --pick${text_reset} called with invalid flake uri: $flake_uri"
		fi

		local raw_apps_choices=($(get_flake_outputs apps "$flake_uri"))
		local apps_choices=($(replace_each "path:$(pwd)" "." "${raw_apps_choices[*]}"))

		if [[ ${#apps_choices[@]} == 0 ]]; then
			log_fatal "Could not find any apps in flake: ${flake_uri}"
		fi

		log_info "Select an app:"
		local app=$(gum choose \
			--height=15 \
			--cursor.foreground="4" \
			--item.foreground="7" \
			--selected.foreground="4" \
			${apps_choices[*]} \
		)

		if [[ -z ${app} ]]; then
			log_fatal "No app selected"
		fi

		rewrite_line "$(log_info "Select an app: ${text_fg_blue}${shell}${text_reset}")"

		nix run "${app}" -- ${passthrough_args[*]}
	else
		if [[ ${#positional_args[@]} == 1 ]]; then
			require_flake_nix
			nix run ".#" -- ${passthrough_args[*]}
		else
			local shell_name=${positional_args[1]}

			if [[ "$shell_name" == *:* ]] || [[ "$shell_name" == *#* ]]; then
				nix run "$shell_name" -- ${passthrough_args[*]}
			else
				require_flake_nix
				nix run ".#${shell_name}" -- ${passthrough_args[*]}
			fi
		fi
	fi
}

#==============================#
#          Execute             #
#==============================#

if [ -z "${positional_args:-}" ]; then
	if [[ $opt_help == true ]]; then
		show_help "flake"
		exit 0
	else
		log_fatal "Called with no arguments. Run with ${text_bold}--help${text_reset} for more information."
	fi
fi

case ${positional_args[0]} in
	new)
		log_debug "Running subcommand: ${text_bold}flake_new${text_reset}"
		flake_new
		;;
	init)
		log_debug "Running subcommand: ${text_bold}flake_init${text_reset}"
		flake_init
		;;
	switch)
		log_debug "Running subcommand: ${text_bold}flake_switch${text_reset}"
		flake_switch
		;;
	build)
		log_debug "Running subcommand: ${text_bold}flake_build${text_reset}"
		flake_build
		;;
	build-nixos|\
	build-nixos-vm|\
	build-darwin|\
	build-system|\
	build-amazon|\
	build-azure|\
	build-cloudstack|\
	build-do|\
	build-gce|\
	build-hyperv|\
	build-install-iso|\
	build-install-iso-hyperv|\
	build-iso|\
	build-kexec|\
	build-kexec-bundle|\
	build-kubevirt|\
	build-lxc|\
	build-lxc-metadata|\
	build-openstack|\
	build-proxmox|\
	build-qcow|\
	build-raw|\
	build-raw-efi|\
	build-sdaarch64|\
	build-sdaarch64-installer|\
	build-vagrant-virtualbox|\
	build-virtualbox|\
	build-vm|\
	build-vm-bootloader|\
	build-vm-nogui|\
	build-vmware)
		log_debug "Running subcommand: ${text_bold}flake_build_system${text_reset}"
		flake_build_system
		;;
	dev)
		log_debug "Running subcommand: ${text_bold}flake_dev${text_reset}"
		flake_dev
		;;
	run)
		log_debug "Running subcommand: ${text_bold}flake_run${text_reset}"
		flake_run
		;;
	*)
		log_fatal "Unknown subcommand: ${text_bold}${positional_args[0]}${text_reset}"
		;;
esac
