echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}check${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Build checks from Nix Flakes.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake check${text_reset} [name] [options]

${text_bold}OPTIONS${text_reset}

  --pick, -p                          Pick a check to check from a list
  --all-systems, -a                   Check all systems instead of just the current one

  --help, -h                          Show this help message
  --debug                             Show debug messages
  --show-trace                        Show a trace when a Nix command fails

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Run all checks for the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake check${text_reset}

  ${text_dim}# Run a specific check for the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake check${text_reset} ${text_underline}my-check${text_reset}

  ${text_dim}# Run a check from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake check${text_reset} ${text_underline}github:snowfall/dotbox#dotbox${text_reset}

  ${text_dim}# Pick a check to run from the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake check${text_reset} --pick

  ${text_dim}# Pick a check to run from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake check${text_reset} ${text_underline}github:snowfall/dotbox${text_reset} --pick
"
