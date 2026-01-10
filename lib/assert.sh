#!/usr/bin/env bash
assert_nonempty() { [[ -n "${1:-}" ]] || die "Expected non-empty value"; }
assert_int() { [[ "${1:-}" =~ ^[0-9]+$ ]] || die "Expected integer"; }
