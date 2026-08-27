#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")" && pwd)
version=$(sed -n 's/^version=//p' "$repo_dir/module/module.prop")
mkdir -p "$repo_dir/dist"
output="$repo_dir/dist/TermuxClarity-${version}.zip"
if [ -e "$output" ]; then
  mv "$output" "$output.previous-$(date +%Y%m%d%H%M%S)"
fi

(cd "$repo_dir/module" && zip -qr "$output" .)
sha256sum "$output"
