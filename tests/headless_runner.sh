#!/bin/bash

# Find a free display number
for i in {99..200}; do
    if [ ! -f "/tmp/.X$i-lock" ]; then
        DISPLAY_NUM=$i
        break
    fi
done

if [ -z "$DISPLAY_NUM" ]; then
    echo "Could not find a free display number."
    exit 1
fi

export DISPLAY=:$DISPLAY_NUM

# Start Xvfb
Xvfb $DISPLAY -screen 0 1280x1024x24 > /dev/null 2>&1 &
XVFB_PID=$!

# Wait for Xvfb to start
sleep 2

# Run the test
"$@"
RET=$?

# Cleanup
kill $XVFB_PID
wait $XVFB_PID 2>/dev/null

exit $RET
