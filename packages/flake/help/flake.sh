echo -e "
${text_bold}${text_fg_blue}flake${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Nix Flakes simplified.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake${text_reset} <command> [options]

${text_bold}COMMANDS${text_reset}

  new                       Create a new flake in a new directory
  init                      Create a new flake in an existing directory
  run                       Run an app
  build                     Build a package
  dev                       Start a development shell
  switch                    Switch system configuration
  build-<target>            Build a target system, see ${text_bold}flake build-system --help${text_reset}

${text_bold}OPTIONS${text_reset}

  --help, -h                Show this help message
  --debug                   Show debug messages
"
