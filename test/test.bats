setup() {
  echo "0" > counter.txt
  echo "1" > success.txt
}

teardown() {
  echo "0" > counter.txt
  echo "1" > success.txt
}

print_run_values() {
  echo "status = ${status}"
  echo "output = ${output}"
  echo "lines = ${lines[@]}"
}

@test "bash should exist" {
  run bash --help
  print_run_values
  [ "${status}" -eq 0 ]
}

@test "debounce.sh should run the debounce action" {
  run bash -c "../debounce.sh ./generate-event-every-two-seconds-twice.sh 3 'echo 0 > success.txt'"
  print_run_values
  [ "${status}" -eq "0" ]
  [ "$(cat success.txt)" -eq "0" ]
}

@test "debounce.sh should debounce the debounce action" {
  run bash -c "../debounce.sh ./generate-event-every-two-seconds-twice.sh 3 'echo 0 > success.txt'"
  EXECUTION_TIME=${SECONDS}
  echo "EXECUTION_TIME = ${EXECUTION_TIME}"
  print_run_values
  [ "${EXECUTION_TIME}" -ge $((3 + 2 + 2)) ]
  [ "${status}" -eq "0" ]
  [ "$(cat success.txt)" -eq "0" ]
}
