echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}update${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Update a Nix Flake's inputs.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake update${text_reset} [...inputs] [options]

${text_bold}OPTIONS${text_reset}

  --pick, -p                          Pick inputs to update from a list.

  --help, -h                          Show this help message
  --debug                             Show debug messages

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Update all flake inputs.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake update${text_reset}

  ${text_dim}# Update one or more specific inputs.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake update${text_reset} ${text_underline}nixpkgs${text_reset} ${text_underline}snowfall-lib${text_reset}

  ${text_dim}# Pick inputs to update from a list.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake update${text_reset} --pick
"
