echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}new${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Create new projects from flake templates.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake new${text_reset} <name> [options]

${text_bold}OPTIONS${text_reset}

  --template, -t <template>           The Nix Flake and name of the template to use
  --pick, -p                          Pick a template from a list

  --help, -h                          Show this help message
  --debug                             Show debug messages
  --show-trace                        Show a trace when a Nix command fails

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Create a new flake and directory my-project with the default template.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake new${text_reset} ${text_underline}my-project${text_reset}

  ${text_dim}# Create a new flake and directory my-project with a custom template.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake new${text_reset} ${text_underline}my-project${text_reset} --template ${text_underline}github:snowfallorg/templates#package${text_reset}

  ${text_dim}# Create a new flake and directory my-project with a template selected from a list.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake new${text_reset} ${text_underline}my-project${text_reset} --pick
"
