#!/usr/bin/env bash
log()  { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; }
err()  { printf '[ERR ] %s\n' "$*" >&2; }
die()  { err "$*"; exit 1; }
