#!/bin/bash
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
