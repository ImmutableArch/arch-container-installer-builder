#!/bin/bash
set -e

OUTDIR="${INPUT_OUTPUT_DIR:-out}"
ROOTFS_PATH="${INPUT_ROOTFS_PATH}"
CUSTOM_PACKAGES="${INPUT_CUSTOM_PACKAGES}"
EXTRA_REPOS="${INPUT_EXTRA_REPOS}"
CUSTOM_GRUB="${INPUT_CUSTOM_GRUB}"
CUSTOM_SYSLINUX="${INPUT_CUSTOM_SYSLINUX}"

WORKDIR="/github/workspace"
PROFILE_DIR="$WORKDIR/.build-profile"

rsync -a /profile/ "$PROFILE_DIR/"

if [ -n "$EXTRA_REPOS" ]; then
  echo "➕ Adding extra repositories to pacman.conf"
  echo "" >> "$PROFILE_DIR/pacman.conf"
  echo "# Extra user repositories" >> "$PROFILE_DIR/pacman.conf"
  echo "$EXTRA_REPOS" >> "$PROFILE_DIR/pacman.conf"
fi

if [ -n "$CUSTOM_PACKAGES" ]; then
  echo "➕ Adding custom packages"
  printf "\n%s\n" "$CUSTOM_PACKAGES" >> "$PROFILE_DIR/packages.x86_64"
fi

if [ -n "$ROOTFS_PATH" ]; then
  echo "📂 Merging user rootfs directory into airootfs/"
  rsync -a "$WORKDIR/$ROOTFS_PATH/" "$PROFILE_DIR/airootfs/"
fi

if [ -n "$INPUT_CUSTOM_PROFILEDEF" ]; then
  echo "📝 Using custom profiledef.sh"
  cp "$WORKDIR/$INPUT_CUSTOM_PROFILEDEF" "$PROFILE_DIR/profiledef.sh"
fi

if [ -n "$CUSTOM_GRUB" ]; then
  echo "🎨 Injecting custom GRUB files…"
  mkdir -p "$PROFILE_DIR/grub"
  rsync -a "$WORKDIR/$CUSTOM_GRUB/" "$PROFILE_DIR/grub/"
fi

if [ -n "$CUSTOM_SYSLINUX" ]; then
  echo "🎨 Injecting custom Syslinux files…"
  mkdir -p "$PROFILE_DIR/syslinux"
  rsync -a "$WORKDIR/$CUSTOM_SYSLINUX/" "$PROFILE_DIR/syslinux/"
fi

echo "🔧 Building Arch OSTree Installer ISO..."
cd /github/workspace

mkdir -p "$OUTDIR"
mkarchiso -v -w work -o "$OUTDIR" /profile

echo "✅ Done! ISO is in $OUTDIR:"
ls "$OUTDIR"
