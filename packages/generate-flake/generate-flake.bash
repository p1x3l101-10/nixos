#!/usr/bin/env bash

FILE="$1"
TMPFILE="$(mktemp)"

nix eval --file "${FILE}" > "${TMPFILE}.raw.nix"