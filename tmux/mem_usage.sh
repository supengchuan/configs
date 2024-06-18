#!/usr/bin/env bash

print_ram_usage() {
  usage=$(free -h | head -2 | tail -1 | awk '{print $3 "/" $2}')
  echo "$usage"
}

main() {
  print_ram_usage
}

main
