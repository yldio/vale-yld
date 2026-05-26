#!/usr/bin/env bats

setup_file() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export PROJECT_ROOT
  export NORMALIZE='[.[]] | flatten | map({check: .Check, line: .Line, match: .Match, severity: .Severity}) | sort_by([.line, .match])'
}

@test "ForbiddenPhrases: all violations match expected output" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/ForbiddenPhrases.md" \| \
    jq "$NORMALIZE"
  [ "$status" -eq 0 ]
  [ "$output" = "$(cat "$PROJECT_ROOT/tests/expected/ForbiddenPhrases.json")" ]
}

@test "ForbiddenPhrases: flags 'Great question'" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/ForbiddenPhrases.md" \| \
    jq -e '[.[]] | flatten | any(.[]; .Match == "Great question")'
  [ "$status" -eq 0 ]
}

@test "ForbiddenPhrases: clean prose passes" {
  run vale "$PROJECT_ROOT/tests/fixtures/ForbiddenPhrases_pass.md"
  [ "$status" -eq 0 ]
}
