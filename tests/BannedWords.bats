#!/usr/bin/env bats

setup_file() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export PROJECT_ROOT
  export NORMALIZE='[.[]] | flatten | map({check: .Check, line: .Line, match: .Match, severity: .Severity}) | sort_by([.line, .match])'
}

@test "BannedWords: all violations match expected output" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/BannedWords.md" \| \
    jq "$NORMALIZE"
  [ "$status" -eq 0 ]
  [ "$output" = "$(cat "$PROJECT_ROOT/tests/expected/BannedWords.json")" ]
}

@test "BannedWords: flags 'delve' as error" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/BannedWords.md" \| \
    jq -e '[.[]] | flatten | any(.[]; .Match == "delve")'
  [ "$status" -eq 0 ]
}

@test "BannedWords: clean prose passes" {
  run vale "$PROJECT_ROOT/tests/fixtures/BannedWords_pass.md"
  [ "$status" -eq 0 ]
}
