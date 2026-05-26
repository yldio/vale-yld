#!/usr/bin/env bats

setup_file() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export PROJECT_ROOT
  export NORMALIZE='[.[]] | flatten | map({check: .Check, line: .Line, match: .Match, severity: .Severity}) | sort_by([.line, .match])'
}

@test "BannedPhrases: all violations match expected output" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/BannedPhrases.md" \| \
    jq "$NORMALIZE"
  [ "$status" -eq 0 ]
  [ "$output" = "$(cat "$PROJECT_ROOT/tests/expected/BannedPhrases.json")" ]
}

@test "BannedPhrases: flags 'plays a vital role'" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/BannedPhrases.md" \| \
    jq -e '[.[]] | flatten | any(.[]; .Match == "plays a vital role")'
  [ "$status" -eq 0 ]
}

@test "BannedPhrases: clean prose passes" {
  run vale "$PROJECT_ROOT/tests/fixtures/BannedPhrases_pass.md"
  [ "$status" -eq 0 ]
}
