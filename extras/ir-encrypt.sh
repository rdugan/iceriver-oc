#!/bin/bash

#   Copyright 2023 rdugan
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

if [ $# != 4 ];
then
  echo "Usage: $0 <bg archive> <miner archive> <model> <name / version>"
  echo "Example: $0 bg.tar miner.tar ks0pro pbfarmerv1"
  exit 1;
fi

if [[ ! $3 =~ ^ks(0|0pro|1|2|3|3m|3l)$ ]];
then
  echo "Model must be one of ks0, ks0pro, ks1, ks2, ks3, ks3m, or ks3l"
  exit 1;
fi

cd $(dirname "$(realpath $0)")

IRPW0=Aptx-4869aptx-\$\*^\(
IRPW1=D\#7tG2\$ePf\ಠ_\ಠ9QwR6v
[[ $3 = "ks0pro" ]] && export IRPW=$IRPW1 || export IRPW=$IRPW0

# generate acceptable names
bgFile=${4}_bg.bgz
minerFile=${4}_${3}miner.bgz
upgradeFile=${4}_${3}update

# create fake salt file
FSTMP=$(mktemp)
dd if=/dev/zero of=$FSTMP bs=1 count=16 status=none

# encrypt inputs and prepend fake salt
CRYPTTMP=$(mktemp)

openssl enc -nosalt -aes-256-cbc -in $1 -out $CRYPTTMP -pass env:IRPW >/dev/null 2>&1
cat $FSTMP $CRYPTTMP > /tmp/${bgFile}

openssl enc -nosalt -aes-256-cbc -in $2 -out $CRYPTTMP -pass env:IRPW >/dev/null 2>&1
cat $FSTMP $CRYPTTMP > /tmp/${minerFile}

# create and encrypt archive of encrypted inputs, and prepend fake salt
tar czf /tmp/${upgradeFile}.tar -C /tmp ${bgFile} ${minerFile}
#cp $1 /tmp/
#tar czf /tmp/${upgradeFile}.tar -C /tmp $1

openssl enc -nosalt -aes-256-cbc -in /tmp/${upgradeFile}.tar -out $CRYPTTMP -pass env:IRPW >/dev/null 2>&1
cat $FSTMP $CRYPTTMP > ${upgradeFile}.bgz

echo "${upgradeFile}.bgz created"
