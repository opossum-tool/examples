#!/usr/bin/env bash

if [[ -z "$1" ]]
then
    echo "Usage: ./build_examples.sh [PATH_TO_RUN_AIOC]"
    echo "Make sure to clone and build AIOC before starting this script:"
    echo "https://github.com/opossum-tool/aioc"
    exit 1
fi
RUN_AIOC_COMMAND="$1"

set -euo pipefail

if [[ ! -f "$RUN_AIOC_COMMAND" ]]
then
    echo "File not found: $RUN_AIOC_COMMAND"
    exit 1
fi

cloneAndScan() {
    name="$1"
    gitRepo="$2"
    commitHash="$3"
    if [[ ! -f "${name}_aioc/merged-opossum.input.json.gz" ]]
    then
        if [[ ! -d "$name" ]]
        then
            git clone "$gitRepo"
        fi
        ( cd "$name"; git checkout "$commitHash" )
        $RUN_AIOC_COMMAND "$name"
    else
        echo "Output ${name}_aioc already exists, skipping."
    fi
}

cloneAndScan "zlib" "git@github.com:madler/zlib" "cacf7f1"
cloneAndScan "antlr4" "git@github.com:antlr/antlr4" "ce3c483ec"
cloneAndScan "reuse-tool" "https://git.fsfe.org/reuse/tool" "89ded70"
cloneAndScan "qutebrowser" "git@qutebrowser/qutebrowser" "4c1334b3b"
cloneAndScan "tools-java" "git@github.com:spdx/tools-java" "89cc3c1"
cloneAndScan "tools-python" "git@github.com:spdx/tools-python" "fd6aeba"
