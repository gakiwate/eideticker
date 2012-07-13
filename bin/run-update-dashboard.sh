#!/bin/sh

set -e

EIDETICKER=$(dirname $0)/../
TESTS="clock taskjs nightly cnn nytimes-scroll nytimes-zoom reddit wikipedia imgur"

if [ $# -gt 0 ]; then
    TESTS=$@
fi

export PATH=$PATH:$HOME/tools/android-sdk-linux/tools:$HOME/tools/android-sdk-linux/platform-tools:$HOME/bin:$HOME/.local/bin

cd $EIDETICKER
. bin/activate

# Clean out /tmp/eideticker directory (in case there are any artifacts
# from unsuccessful runs kicking around)
rm -rf /tmp/eideticker/*

# Expire old captures/videos
./bin/expire.py

# Update apps on the phone to the latest
./bin/update-phone.py

for TEST in $TESTS; do
  echo "Running $TEST"
  ./bin/update-dashboard.py --product nightly --num-runs 5 $TEST src/dashboard
done
