#!/usr/bin/env bash
# Erzeugt die Screenshots für README.md mit Chrome im Headless-Modus.
# Jede Szene wird über den Screenshot-Modus des Spiels aufgebaut: index.html#shot=<szene>
#
#   bash tools/screenshots.sh            # alle Szenen
#   bash tools/screenshots.sh canyon     # nur eine Szene
#
# Anderen Browser verwenden: CHROME=/pfad/zu/chromium bash tools/screenshots.sh
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
OUT=docs/screenshots
SCENES=("${@:-title combat canyon mountains volcano city sea touch}")
mkdir -p "$OUT"

# Eigenes Wegwerf-Profil, damit ein bereits laufendes Chrome nicht stört
PROFILE="$(mktemp -d)"
trap 'rm -rf "$PROFILE"' EXIT

for scene in ${SCENES[@]}; do
  size=1400,860
  [ "$scene" = touch ] && size=1180,820          # iPad Air quer
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --no-first-run \
    --user-data-dir="$PROFILE" --window-size=$size --virtual-time-budget=4000 \
    --screenshot="$OUT/$scene.png" "file://$PWD/index.html#shot=$scene" >/dev/null 2>&1
  echo "✓ $OUT/$scene.png"
done
