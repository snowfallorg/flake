echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}option${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Show NixOS options from Nix Flakes.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} [option] [options]
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} <hostname> [option] [options]
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} <flake-uri> [option] [options]

${text_bold}OPTIONS${text_reset}

  --pick, -p                          Pick options from a list

  --help, -h                          Show this help message
  --debug                             Show debug messages
  --show-trace                        Show a trace when a Nix command fails

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Show options for the current host in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset}

  ${text_dim}# Show options for a specific host.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} ${text_underline}my-host${text_reset}

  ${text_dim}# Show a specific option for a specific host.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} ${text_underline}my-host${text_reset} ${text_underline}services.openssh${text_reset}

  ${text_dim}# Show options for a flake's host.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} ${text_underline}github:jakehamilton/config#bismuth${text_reset}

  ${text_dim}# Show a specific option for a flake's host.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} ${text_underline}github:jakehamilton/config#bismuth${text_reset} ${text_underline}services.openssh${text_reset}

  ${text_dim}# Pick options for the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} --pick

  ${text_dim}# Pick options from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake option${text_reset} ${text_underline}github:jakehamilton/config${text_reset} --pick
"
