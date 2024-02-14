echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}boot${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Set a NixOS configuration as the bootable system.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake boot${text_reset} <name> [options]

${text_bold}OPTIONS${text_reset}

  --help, -h                          Show this help message
  --debug                             Show debug messages
  --show-trace                        Show a trace when a Nix command fails

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Boot a configuration with the same hostname from the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake boot${text_reset}

  ${text_dim}# Boot a specific configuration from the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake boot${text_reset} ${text_underline}my-system${text_reset}

  ${text_dim}# Pick a configuration to boot from the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake boot${text_reset} --pick

  ${text_dim}# Boot a configuration from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake boot${text_reset} ${text_underline}github:jakehamilton/config#bismuth${text_reset}

  ${text_dim}# Pick configuration from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake boot${text_reset} ${text_underline}github:jakehamilton/config${text_reset} --pick
"
