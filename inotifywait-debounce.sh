#! /usr/bin/env bash
set -Ceuo pipefail

WATCH_FILE_PATH=$1
DEBOUNCE_INTERVAL_SECONDS=$2
DEBOUNCE_ACTION="${@:3}"
DEBOUNCE_PID=""

run_debounce_action() {
    echo "Waiting debounce interval to perform debounce action: ${DEBOUNCE_ACTION}"
    sleep $((DEBOUNCE_INTERVAL_SECONDS))
    echo "Running debounce action"
    bash -c "$DEBOUNCE_ACTION"
}

inotifywait_with_debounce() {
    while
        inotifywait -e MOVE_SELF --format %e \
        "$WATCH_FILE_PATH"
    do
        echo "FILE_SAVED at SECONDS: ${SECONDS}"
        if test -n "$DEBOUNCE_PID" && ps -p $DEBOUNCE_PID > /dev/null ; then
            echo "Killing debounce PID: ${DEBOUNCE_PID}"
            kill -9 $DEBOUNCE_PID
        fi
        run_debounce_action &
        DEBOUNCE_PID=$!
    done
}

inotifywait_with_debounce
