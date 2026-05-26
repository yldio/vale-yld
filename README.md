# vale-yld

A [Vale](https://vale.sh) style package for technical writing. Targets common patterns in AI-generated and over-formal prose: banned vocabulary, vague phrasing, inconsistent technology names, and structural anti-patterns.

Primarily designed for technical blog posts, but usable in any developer writing context.

## Installation

Add to your `.vale.ini`:

```ini
StylesPath = .vale/styles
MinAlertLevel = suggestion
Packages = GitHub/yldio/vale-yld

[*.md]
BasedOnStyles = YLD
```

Then run:

```sh
vale sync
```

## Rules

| Rule | Level | What it catches |
|---|---|---|
| `YLD.BannedWords` | error | Overused words: _delve_, _leverage_, _robust_, _seamless_, and 16 others |
| `YLD.BannedPhrases` | error | Clichéd constructions: _"At its core"_, _"In the realm of"_, _"Plays a vital role"_, and others |
| `YLD.SummaryPhrases` | error | Section-ending restaters: _"In conclusion"_, _"To summarize"_, _"All in all"_, and others |
| `YLD.ForbiddenPhrases` | error | Sycophancy, hedging, meta-commentary, and inanimate attribution |
| `YLD.VagueTrailing` | warning | Trailing significance clauses: _"…, highlighting its importance"_ |
| `YLD.Transitions` | warning | Overused connectors: _Moreover_, _Furthermore_, _Additionally_ |
| `YLD.Terminology` | warning | Official technology names: _Javascript_ → _JavaScript_, _NodeJS_ → _Node.js_, etc. |

## Disabling rules

Disable a specific rule in your `.vale.ini`:

```ini
[*.md]
BasedOnStyles = YLD
YLD.Transitions = NO
```

Disable inline with a Vale comment:

```markdown
<!-- vale YLD.BannedWords = NO -->
This is a deliberate exception.
<!-- vale YLD.BannedWords = YES -->
```

## Adding project-specific terminology

Create a local style alongside `YLD`:

```ini
StylesPath = .vale/styles
Packages = GitHub/yldio/vale-yld

[*.md]
BasedOnStyles = YLD, Local
```

Then add `.vale/styles/Local/Terminology.yml`:

```yaml
extends: substitution
message: "Use the official name '%s' instead of '%s'."
level: warning
ignorecase: false
action:
  name: replace
swap:
  MyFramework: MyFramework  # your project-specific terms here
```

## CI integration

### GitHub Actions

```yaml
name: Prose lint

on: [pull_request]

jobs:
  vale:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: errata-ai/vale-action@v2
        with:
          files: '**/*.md'
```

### Pre-commit hook

```yaml
repos:
  - repo: https://github.com/errata-ai/vale
    rev: v3.7.1
    hooks:
      - id: vale
```

## Requirements

Vale v2.28 or later.
