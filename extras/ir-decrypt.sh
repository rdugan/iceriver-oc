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

if [ $# != 2 ];
then
  echo "Usage: $0 <bgz file> <model>"
  echo "Example: $0 pbfarmerv1_ks0update.bgz ks0"
  exit 1;
fi

if [[ ! $2 =~ ^ks(0|0pro|1|2|3|3m|3l)$ ]];
then
  echo "Model must be one of ks0, ks0pro, ks1, ks2, ks3, ks3m, or ks3l"
  exit 1;
fi

cd $(dirname "$(realpath $0)")

IRPW0=Aptx-4869aptx-\$\*^\(
IRPW1=D\#7tG2\$ePf\ಠ_\ಠ9QwR6v
[[ $2 = "ks0pro" ]] && export IRPW=$IRPW1 || export IRPW=$IRPW0

# extract filenames w/o path or extensions
f=${1##*/}
filename=${f%.*}
outputFile=${filename}.tgz
encodedFile=${outputFile}.enc

# remove fake salt
dd if=$1 of=${encodedFile} bs=16 skip=1 status=none

# decrypt file
openssl enc -d -nosalt -aes-256-cbc -in ${encodedFile} -out ${outputFile} -pass env:IRPW >/dev/null 2>&1

rm $encodedFile

echo "${outputFile} created"
