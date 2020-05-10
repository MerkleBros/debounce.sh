#! /usr/bin/env bash
set -Ceuo pipefail

readonly WATCH_FILE_PATH="$1"
readonly DEBOUNCE_INTERVAL_SECONDS="$2"
readonly DEBOUNCE_ACTION="${*:3}"
debounce_pid=""

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
        if test -n "$debounce_pid" && ps -p $debounce_pid > /dev/null ; then
            echo "Killing debounce PID: ${debounce_pid}"
            kill $debounce_pid
        fi
        run_debounce_action &
        debounce_pid=$!
    done
}

inotifywait_with_debounce
