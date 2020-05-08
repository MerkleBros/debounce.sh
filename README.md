# inotifywait-debounce
Watch a file for changes and perform an action when the file changes.

The action is debounced. This means that execution of the action is delayed each time the file is changed - the action is only performed after the file has not changed for some time interval.

Intended for pushing a file to Github whenever it is saved.
