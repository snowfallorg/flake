echo -e "
${text_bold}${text_fg_blue}flake${text_reset} ${text_fg_white}build-system${text_reset}

${text_bold}DESCRIPTION${text_reset}

  Build NixOS, nix-darwin, and other types of systems.

${text_bold}USAGE${text_reset}

  ${text_dim}\$${text_reset} ${text_bold}flake build-${text_underline}<target>${text_reset} [name] [options]

${text_bold}OPTIONS${text_reset}

  --pick, -p                          Pick a package to build from a list

  --help, -h                          Show this help message
  --debug                             Show debug messages
  --show-trace                        Show a trace when a Nix command fails

${text_bold}SUPPORTED TARGETS${text_reset}

  build-system                        Automatically chooses nixos/darwin based on host platform
  build-nixos                         NixOS system
  build-nixos-vm                      NixOS qemu virtual machine
  build-darwin                        nix-darwin system
  build-amazon                        Amazon EC2 image
  build-cloudstack                    qcow2 image for cloudstack
  build-do                            Digital Ocean image
  build-gce                           Google Compute image
  build-hyperv                        Hyper-V Image (Generation 2 / VHDX)
  build-install-iso                   Installer ISO
  build-install-iso-hyperv            Installer ISO with enabled hyper-v support
  build-iso                           ISO
  build-kexec                         kexec tarball (extract to / and run /kexec_nixos)
  build-kexec-bundle                  Same as kexec, but it's an executable
  build-kubevirt                      KubeVirt image
  build-lxc                           Create a tarball which is importable as an lxc container
  build-lxc-metadata                  The necessary metadata for the lxc image to start
  build-openstack                     qcow2 image for openstack
  build-proxmox                       VMA file for proxmox
  build-qcow                          qcow2 image
  build-raw                           Raw image with bios/mbr
  build-raw-efi                       Raw image with efi support
  build-sdaarch64                     Like sd-aarch64-installer, but does not use default installer image config
  build-sdaarch64-installer           Create an installer sd card for aarch64
  build-vagrant-virtualbox            VirtualBox image for Vagrant
  build-virtualbox                    VirtualBox VM
  build-vm                            Only used as a qemu-kvm runner
  build-vm-bootloader                 Same as vm, but uses a real bootloader instead of netbooting
  build-vm-nogui                      Same as vm, but without a GUI
  build-vmware                        VMWare image (VMDK)

${text_bold}EXAMPLES${text_reset}

  ${text_dim}# Build the system with the same hostname from the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build-system${text_reset}

  ${text_dim}# Build the NixOS system with the same hostname from the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build-nixos${text_reset}

  ${text_dim}# Build a specific nix-darwin system from the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build-darwin${text_reset} ${text_underline}my-system${text_reset}

  ${text_dim}# Build the system with the same hostname from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build-system${text_reset} ${text_underline}github:jakehamilton/config#bismuth${text_reset}

  ${text_dim}# Pick and build a system from the flake in the current directory${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build-system${text_reset} --pick

  ${text_dim}# Pick and build a system from a specific flake.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build-system${text_reset} ${text_underline}github:jakehamilton/config${text_reset} --pick

  ${text_dim}# Build a specific ISO from the flake in the current directory.${text_reset}
  ${text_dim}\$${text_reset} ${text_bold}flake build-iso${text_reset} ${text_underline}my-iso-system${text_reset}
"
