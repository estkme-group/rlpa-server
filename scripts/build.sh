#!/bin/bash
set -xeuo pipefail

cd lpac || exit 1

cmake . -DLPAC_WITH_APDU_PCSC=off -DLPAC_WITH_APDU_AT=off
make -j

cp ../rlpa-server.php ./output
