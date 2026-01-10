#!/usr/bin/env bash
exec_remote() {
  local cmd="${*: -1}"
  local -a runner=( "${@:1:$#-1}" )
  "${runner[@]}" bash -lc "$cmd"
}
