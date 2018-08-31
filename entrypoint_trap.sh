#!/bin/bash

export $(egrep -v '^#' .env | xargs)

pid=0

# SIGUSR1- Single handler
my_handler() {
    if [ $pid -ne 0 ]; then
        kill -SIGUSR1 "$pid"
        wait "$pid"
    fi
    exit 144;
}

# Trap and handle the user defind singnal.
trap 'kill ${!}; my_handler' SIGUSR1

/usr/local/bin/testserver --address 0.0.0.0 &
pid="$!"

# wait indefinitely
while true
do
    tail -f /dev/null & wait ${!}
done
