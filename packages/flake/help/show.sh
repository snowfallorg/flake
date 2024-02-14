echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}show${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Show the outputs of a Nix Flake.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake show${text_reset} <name> [options]

${text_bold}OPTIONS${text_reset}

  --help, -h                          Show this help message
  --debug                             Show debug messages
  --show-trace                        Show a trace when a Nix command fails

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Show outputs from the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake show${text_reset}

  ${text_dim}# Show outputs from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake show${text_reset} ${text_underline}github:jakehamilton/config${text_reset}
"
