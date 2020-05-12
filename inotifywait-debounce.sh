#! /usr/bin/env bash
set -Ceuo pipefail

inotifywait -e MOVE_SELF --format %e "/home/patrick/writing/recurse-journal/recurse-journal.md"
