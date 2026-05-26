#!/usr/bin/env bats

setup_file() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export PROJECT_ROOT
  export NORMALIZE='[.[]] | flatten | map({check: .Check, line: .Line, match: .Match, severity: .Severity}) | sort_by([.line, .match])'
}

@test "SummaryPhrases: all violations match expected output" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/SummaryPhrases.md" \| \
    jq "$NORMALIZE"
  [ "$status" -eq 0 ]
  [ "$output" = "$(cat "$PROJECT_ROOT/tests/expected/SummaryPhrases.json")" ]
}

@test "SummaryPhrases: flags 'In conclusion'" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/SummaryPhrases.md" \| \
    jq -e '[.[]] | flatten | any(.[]; .Match == "In conclusion")'
  [ "$status" -eq 0 ]
}

@test "SummaryPhrases: clean prose passes" {
  run vale "$PROJECT_ROOT/tests/fixtures/SummaryPhrases_pass.md"
  [ "$status" -eq 0 ]
}
