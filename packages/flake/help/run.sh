echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}run${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Run apps from Nix Flakes.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake run${text_reset} <name> [options]

${text_bold}OPTIONS${text_reset}

  --pick, -p                          Pick a package to build from a list

  --help, -h                          Show this help message
  --debug                             Show debug messages
  --show-trace                        Show a trace when a Nix command fails

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Run the default app of the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake run${text_reset}

  ${text_dim}# Run a specific app of the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake run${text_reset} ${text_underline}my-package${text_reset}

  ${text_dim}# Run a specific app from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake run${text_reset} ${text_underline}github:snowfall/dotbox#dotbox${text_reset}

  ${text_dim}# Pick an app to run from the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake run${text_reset} --pick

  ${text_dim}# Pick an app to run from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake run${text_reset} ${text_underline}github:snowfall/dotbox${text_reset} --pick
"
