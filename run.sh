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

set +eux

if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  echo "Installing private ssh key for vm"
  cp ./id_ed25519.txt ~/.ssh/id_ed25519
  chmod 600 ~/.ssh/id_ed25519
  cat known_hosts >> ~/.ssh/known_hosts
fi

    #-nographic \
echo "Launching AL2 image"
qemu-system-x86_64 -m 4096 \
    -smp cpus=8 \
    -display none \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -hdb seed.img \
    -hda amzn2-kvm-2.0.20230628.0-x86_64.xfs.gpt.qcow2 &
# TODO: Validate disk perf options
# TODO: compress/clean qcow2 image

# This might have better perf?
#   -drive if=virtio,format=qcow2,file=amzn2-kvm-2.0.20230628.0-x86_64.xfs.gpt.qcow2 \

let counter=0
let maxwait=30
ssh -p 2222 -qo ConnectTimeout=1 codebuild@localhost hostname
while test $? -gt 0; do 
	  if [ "$counter" -ge "$maxwait" ]; then
		  echo "Timed out waiting for qemu vm to be reachable"
		  return 255
	  fi
	  ((counter++))
	  echo "Waiting for ssh to come up"
	  sleep 2
          ssh -p 2222 -qo ConnectTimeout=1 codebuild@localhost hostname
done

echo "Qemu VM ready for use $(date)"
