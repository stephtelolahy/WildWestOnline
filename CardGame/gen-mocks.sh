#!/bin/bash
TARGET_NAME="CardGame"
INPUT_DIR="Sources/CardGame"
OUTPUT_FILE="Tests/CardGameTests/GeneratedMocks.swift"

.build/checkouts/Cuckoo/run generate --testable "${TARGET_NAME}" \
--output "${OUTPUT_FILE}" \
"${INPUT_DIR}/CardGame.swift" \
"${INPUT_DIR}/CardGameEngine.swift"

# TODO: run on every build with swift package plugins
# TODO: use mock classes from other packages
