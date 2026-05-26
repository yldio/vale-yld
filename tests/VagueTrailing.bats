#!/usr/bin/env bats

setup_file() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export PROJECT_ROOT
  export NORMALIZE='[.[]] | flatten | map({check: .Check, line: .Line, match: .Match, severity: .Severity}) | sort_by([.line, .match])'
}

@test "VagueTrailing: all violations match expected output" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/VagueTrailing.md" \| \
    jq "$NORMALIZE"
  [ "$status" -eq 0 ]
  [ "$output" = "$(cat "$PROJECT_ROOT/tests/expected/VagueTrailing.json")" ]
}

@test "VagueTrailing: flags trailing ', highlighting'" {
  run bats_pipe --returned-status -1 \
    vale --output=JSON "$PROJECT_ROOT/tests/fixtures/VagueTrailing.md" \| \
    jq -e '[.[]] | flatten | any(.[]; .Check == "YLD.VagueTrailing" and (.Match | test("highlighting")))'
  [ "$status" -eq 0 ]
}

@test "VagueTrailing: clean prose passes" {
  run vale "$PROJECT_ROOT/tests/fixtures/VagueTrailing_pass.md"
  [ "$status" -eq 0 ]
}
