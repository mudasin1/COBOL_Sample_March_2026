#!/bin/sh
# Golden-file integration tests (stdout only; drivers may use fixed dates).
set -eu
ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
BIN="${ROOT}/build/bin"
OUT="${ROOT}/tests/actual"
EXP="${ROOT}/tests/expected"
mkdir -p "$OUT"
FAILED=0

run_one() {
	name="$1"
	prog="$2"
	"$prog" > "${OUT}/${name}.out"
	if ! diff -q "${EXP}/${name}.out" "${OUT}/${name}.out" >/dev/null 2>&1; then
		echo "FAIL: $name" >&2
		diff -u "${EXP}/${name}.out" "${OUT}/${name}.out" >&2 || true
		FAILED=1
	else
		echo "OK:   $name"
	fi
}

run_one "nb_issue_ok" "${BIN}/driver-nbuw001"
run_one "svc_billing_mode_ok" "${BIN}/driver-svcbill001"
run_one "clm_approve_ok" "${BIN}/driver-clmadj001"

if [ "$FAILED" -ne 0 ]; then
	exit 1
fi
