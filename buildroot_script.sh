#!/bin/bash

# Clone Buildroot repository
git clone https://github.com/buildroot/buildroot.git
cd buildroot

# Checkout a specific release (optional)
# git checkout <release-tag>

# Configure Buildroot
make defconfig

# Customize the configuration
# Uncomment and modify the following lines as needed
# make menuconfig
# make savedefconfig

# Apply optimizations for smallest image
sed -i 's/# BR2_STRIP_STRIP_DEBUG=y/BR2_STRIP_STRIP_DEBUG=y/' .config
sed -i 's/# BR2_STRIP_EXCLUDE_STRIP_STATIC_LIB=y/BR2_STRIP_EXCLUDE_STRIP_STATIC_LIB=y/' .config
sed -i 's/# BR2_TARGET_OPTIMIZATION="-Os"/BR2_TARGET_OPTIMIZATION="-Os"/' .config
sed -i 's/# BR2_TARGET_ROOTFS_TAR=y/BR2_TARGET_ROOTFS_TAR=y/' .config
sed -i 's/# BR2_TARGET_ROOTFS_TAR_GZIP=y/BR2_TARGET_ROOTFS_TAR_GZIP=y/' .config
echo 'BR2_TARGET_ROOTFS_TAR_LZMA=y' >> .config
echo 'BR2_TARGET_ROOTFS_TAR_XZ=y' >> .config

# Build the image
make

# Move the generated image to a separate directory
mkdir -p ./output/
cp output/images/*.img ./output/

# Cleanup Buildroot build files
make clean

# Optionally, commit and push the generated image to a Git repository
# Uncomment and modify the following lines as needed
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
git add ./output/*.img
git commit -m "Add generated image"
git push
