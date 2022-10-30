echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}init${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Initialize a flake in an existing project.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake init${text_reset} <name> [options]

${text_bold}OPTIONS${text_reset}

  --template, -t <template>           The Nix Flake and name of the template to use
  --pick, -p                          Pick a template from a list

  --help, -h                          Show this help message
  --debug                             Show debug messages

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Create a new flake in the current directory with the default template.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake init${text_reset}

  ${text_dim}# Create a new flake in the current directory with a custom template.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake init${text_reset} --template ${text_underline}github:snowfallorg/templates#package${text_reset}

  ${text_dim}# Create a new flake in the current directory with a template selected from a list.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake init${text_reset} --pick
"
