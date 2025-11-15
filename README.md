# Build ArchISO Action

Build a fully customizable Arch Linux ISO using archiso.

## Inputs

| Name | Description | Required | Default |
|------|-------------|----------|---------|
| `profile-path` | Path to a custom ArchISO profile | ❌ | Uses default profile |
| `rootfs-path` | Extra files/directories to merge into airootfs/ | ❌ | – |
| `custom-packages` | Additional packages to install | ❌ | – |
| `extra-repos` | Additional pacman repositories | ❌ | – |
| `custom-grub` | Folder containing custom GRUB theme/config | ❌ | – |
| `custom-syslinux` | Folder containing custom Syslinux files | ❌ | – |
| `profiledef-overrides` | Lines to append or override in profiledef.sh | ❌ | – |
| `custom-profiledef` | Path to a complete custom profiledef.sh | ❌ | – |
| `output-dir` | Output folder for ISO | ❌ | `out` |

## Outputs

| Name | Description |
|------|-------------|
| `iso-path` | Path to the built ISO |
| `sha256` | SHA256 checksum of the ISO |

## Example usage

```yaml
name: Build Custom Arch ISO
on:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build ISO
        uses: mikusiowy2/build-archiso-action@v1
        with:
          custom-packages: "vim neofetch"
          extra-repos: |
            [chaotic-aur]
            Server = https://geo-mirror.chaotic.cx/$repo/$arch
          profiledef-overrides: |
            iso_name="mikusiowy-arch"
            iso_label="MIKUSIARCH_2025"

## License
MIT License
