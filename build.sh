#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd "$(dirname "$0")" && pwd)
version=$(sed -n 's/^version=//p' "$repo_dir/module/module.prop")
mkdir -p "$repo_dir/dist"
rm -f "$repo_dir/dist/TermuxClarity-${version}.zip"

(cd "$repo_dir/module" && zip -qr "$repo_dir/dist/TermuxClarity-${version}.zip" .)
sha256sum "$repo_dir/dist/TermuxClarity-${version}.zip"
