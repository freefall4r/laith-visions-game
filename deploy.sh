#!/bin/bash
# Push the latest version live to https://freefall4r.github.io/laith-visions-game/
cd "$(dirname "$0")" || exit 1
git add -A
git commit -m "${1:-update}" || { echo "nothing to deploy"; exit 0; }
git push
echo "✅ pushed — live link updates in ~1 minute:"
echo "   https://freefall4r.github.io/laith-visions-game/"
