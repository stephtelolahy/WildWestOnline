#!/bin/bash
TARGET_NAME="CardGame"
INPUT_DIR="Sources/CardGame"
OUTPUT_FILE="Tests/CardGameTests/GeneratedMocks.swift"

set -eu
cd "$(dirname "$0")"
swift package describe --type json > project.json
.build/checkouts/Cuckoo/run generate --testable "${TARGET_NAME}" \
--output "${OUTPUT_FILE}" \
"${INPUT_DIR}/CardGame.swift" \
"${INPUT_DIR}/CardGameEngine.swift" \
"../GameDSL/Sources/GameDSL/Event.swift"
