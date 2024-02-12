#!/usr/bin/env bash
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#  http://aws.amazon.com/apache2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.
#

# The Al2 version at https://cdn.amazonlinux.com/os-images/2.0.20230628.0/
# ships with the 4.x kernel, an update and reboot is required.
# https://repost.aws/knowledge-center/amazon-linux-2-kernel-upgrade
sudo amazon-linux-extras install kernel-5.15 -y
sudo yum erase -y postfix kernel-4.14.318 kernel-4.14.320 man-pages
sudo yum install -y git

sudo touch /etc/modules-load.d/tls.conf
sh <(curl -L https://nixos.org/nix/install) --no-daemon
echo '. /home/codebuild/.nix-profile/etc/profile.d/nix.sh' > ~/.bashrc
mkdir -p /home/codebuild/.config/nix
echo 'extra-experimental-features = nix-command flakes' > /home/codebuild/.config/nix/nix.conf

# Clean
sudo  rm -rf /var/cache/yum

echo "Be sure to reboot"
# compress the qcow? qemu-img convert -O qcow2 original_image.qcow2 deduplicated_image.qcow2
