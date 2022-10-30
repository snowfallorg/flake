echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}dev${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Run development shells.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake dev${text_reset} [name] [options]

${text_bold}OPTIONS${text_reset}

  --pick, -p                          Pick a package to build from a list

  --help, -h                          Show this help message
  --debug                             Show debug messages

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Open the default development shell of the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake dev${text_reset}

  ${text_dim}# Open a specific development shell of the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake dev${text_reset} ${text_underline}my-shell${text_reset}

  ${text_dim}# Open a development shell from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake dev${text_reset} ${text_underline}github:snowfall/dotbox#dotbox${text_reset}

  ${text_dim}# Pick a development shell from the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake dev${text_reset} --pick

  ${text_dim}# Pick a development shell from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake dev${text_reset} ${text_underline}github:snowfall/dotbox${text_reset} --pick
"
