#!/bin/bash

set -eu

 if [[ ! -f amzn2-kvm-2.0.20230628.0-x86_64.xfs.gpt.qcow2 ]]; then
   wget https://cdn.amazonlinux.com/os-images/2.0.20230628.0/kvm/amzn2-kvm-2.0.20230628.0-x86_64.xfs.gpt.qcow2
 fi


if [[ ! -f seed.img ]]; then
  echo "Regenerating cloud-init seed image...on ubuntu"
  # https://cdn.amazonlinux.com/os-images/2.0.20230628.0/README.cloud-init
  cloud-localds -f iso9660 -m local seed.img user-data.yml 
fi



#cleanup:
# sudo  rm -rf /var/cache/yum