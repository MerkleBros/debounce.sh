COUNTER="$(cat counter.txt)"
if test "${COUNTER}" -eq "2"; then
    exit 1
fi
COUNTER=$((COUNTER + 1))
echo "${COUNTER}" > counter.txt
sleep 2
exit 0
