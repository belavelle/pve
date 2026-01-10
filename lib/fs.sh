#!/usr/bin/env bash
mkdirp() { install -d -- "$1"; }
write_file_stdin() {
  local path="$1"
  local dir
  dir="$(dirname -- "$path")"
  mkdirp "$dir"
  cat > "$path"
}
