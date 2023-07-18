#!/bin/bash

set -eu

# If [ ! -f amzn2-kvm-2.0.20230628.0-x86_64.xfs.gpt.qcow2 ]; then
#   wget https://cdn.amazonlinux.com/os-images/2.0.20230628.0/kvm/amzn2-kvm-2.0.20230628.0-x86_64.xfs.gpt.qcow2
# fi

echo "Regenerating cloud-init seed image...on ubuntu"
# https://cdn.amazonlinux.com/os-images/2.0.20230628.0/README.cloud-init
cloud-localds -f iso9660 -m local seed.img user-data.yml 

echo "Launching AL2 image"
qemu-system-x86_64 -m 1024 \
    -nographic \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -hdb seed.img \
    -hda amzn2-kvm-2.0.20230628.0-x86_64.xfs.gpt.qcow2
# TODO: headless
# TODO: console loggin?
# TODO: Validate disk perf options

# This might have better perf?
#   -drive if=virtio,format=qcow2,file=amzn2-kvm-2.0.20230628.0-x86_64.xfs.gpt.qcow2 \
