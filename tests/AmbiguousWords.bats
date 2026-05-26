#!/usr/bin/env bats

setup_file() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export PROJECT_ROOT
  export NORMALIZE='[.[]] | flatten | map({check: .Check, line: .Line, match: .Match, severity: .Severity}) | sort_by([.line, .match])'
}

@test "AmbiguousWords: all violations match expected output" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/AmbiguousWords.md" \| \
    jq "$NORMALIZE"
  [ "$status" -eq 0 ]
  [ "$output" = "$(cat "$PROJECT_ROOT/tests/expected/AmbiguousWords.json")" ]
}

@test "AmbiguousWords: flags 'leverage' as warning" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/AmbiguousWords.md" \| \
    jq -e '[.[]] | flatten | any(.[]; .Match == "leverage" and .Severity == "warning")'
  [ "$status" -eq 0 ]
}

@test "AmbiguousWords: clean prose passes" {
  run vale "$PROJECT_ROOT/tests/fixtures/AmbiguousWords_pass.md"
  [ "$status" -eq 0 ]
}
