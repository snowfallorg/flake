echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}build${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Build packages from Nix Flakes.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake build${text_reset} [name] [options]

${text_bold}OPTIONS${text_reset}

  --pick, -p                          Pick a package to build from a list

  --help, -h                          Show this help message
  --debug                             Show debug messages
  --show-trace                        Show a trace when a Nix command fails

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Build the default package of the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build${text_reset}

  ${text_dim}# Build a specific package of the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build${text_reset} ${text_underline}my-package${text_reset}

  ${text_dim}# Build a package from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build${text_reset} ${text_underline}github:snowfall/dotbox#dotbox${text_reset}

  ${text_dim}# Pick a package to build from the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build${text_reset} --pick

  ${text_dim}# Pick a package to build from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build${text_reset} ${text_underline}github:snowfall/dotbox${text_reset} --pick
"
