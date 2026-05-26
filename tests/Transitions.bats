#!/usr/bin/env bats

setup_file() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export PROJECT_ROOT
  export NORMALIZE='[.[]] | flatten | map({check: .Check, line: .Line, match: .Match, severity: .Severity}) | sort_by([.line, .match])'
}

@test "Transitions: all violations match expected output" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/Transitions.md" \| \
    jq "$NORMALIZE"
  [ "$status" -eq 0 ]
  [ "$output" = "$(cat "$PROJECT_ROOT/tests/expected/Transitions.json")" ]
}

@test "Transitions: flags 'Moreover'" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/Transitions.md" \| \
    jq -e '[.[]] | flatten | any(.[]; .Match == "Moreover")'
  [ "$status" -eq 0 ]
}

@test "Transitions: clean prose passes" {
  run vale "$PROJECT_ROOT/tests/fixtures/Transitions_pass.md"
  [ "$status" -eq 0 ]
}
