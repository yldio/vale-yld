# vale-yld Design

A public Vale style package targeting technical blog posts and general developer writing. Reduces AI-generated prose patterns, enforces plain language, and ensures consistent technology naming.

## Package Structure

```
vale-yld/
├── YLD/
│   ├── BannedWords.yml       # substitution — banned vocab with replacements
│   ├── BannedPhrases.yml     # existence — banned multi-word constructions
│   ├── VagueTrailing.yml     # existence — trailing "-ing significance" clauses
│   ├── Transitions.yml       # existence — overused connectors
│   ├── SummaryPhrases.yml    # existence — "In conclusion", "To summarize", etc.
│   ├── ForbiddenPhrases.yml  # existence — sycophancy, hedging, meta-commentary
│   └── Terminology.yml       # substitution — official technology names
├── .vale.ini                  # starter config for adopters
└── README.md
```

## Distribution

Vale v2+ GitHub package. Adopters add to their `.vale.ini`:

```ini
StylesPath = .vale/styles
Packages = GitHub/yldio/vale-yld

[*.md]
BasedOnStyles = YLD
```

Then run `vale sync` to download the package.

## Rules

### BannedWords.yml

- Type: `substitution`
- Level: `error`
- Maps banned words to their primary replacement. Vale uses this for auto-fix in editors.
- Full list: delve, tapestry, testament, multifaceted, vibrant, pivotal, realm, meticulous, underscore, intricacies, nuanced, landscape (figurative), cutting-edge, revolutionary, embark, foster, leverage, robust, seamless, synergy

### BannedPhrases.yml

- Type: `existence`
- Level: `error`
- Flags multi-word constructions that are never acceptable.
- Includes: "It's important to note", "In today's ever-evolving world", "In the realm of", "A testament to", "Plays a vital role", "At its core", "It's not just X it's Y", and others from the source document.

### VagueTrailing.yml

- Type: `existence`
- Level: `warning`
- Catches sentences that end with a comma followed by a vague present participle that claims false analytical weight.
- Participles: highlighting, underscoring, emphasizing, reflecting, demonstrating
- Example: "She won three awards, underscoring her influence." → "She won three awards."

### Transitions.yml

- Type: `existence`
- Level: `warning`
- Flags overused transition words. Warning not error — occasional use is acceptable.
- Tokens: Moreover, Furthermore, Additionally, "On the other hand", "In addition"

### SummaryPhrases.yml

- Type: `existence`
- Level: `error`
- Flags section-ending summary openers. Always wrong — sections should end by finishing the thought.
- Tokens: "In summary", "In conclusion", "In essence", "Overall", "To summarize", "To sum up", "All in all"

### ForbiddenPhrases.yml

- Type: `existence`
- Level: `error`
- Covers sycophancy, hedging, meta-commentary, and inanimate attribution — phrases that add no information.
- Includes: "Great question", "Certainly!", "I'd be happy to", "It's worth noting", "As of my last update", "this statistic highlights", "the report emphasizes"

### Terminology.yml

- Type: `substitution`
- Level: `warning`
- Enforces official technology names. Warning not error — wrong casing may appear in a quote or title the author doesn't control.
- Ships with common terms: Javascript→JavaScript, Typescript→TypeScript, NodeJS/Nodejs→Node.js, NPM→npm, Github→GitHub, Golang→Go, and others.
- Adopters add project-specific terms via a second local style listed in `BasedOnStyles`.

## Severity Levels

| Rule | Level | Rationale |
|---|---|---|
| BannedWords | error | Never acceptable |
| BannedPhrases | error | Never acceptable |
| SummaryPhrases | error | Never acceptable |
| ForbiddenPhrases | error | Never acceptable |
| VagueTrailing | warning | Rarely acceptable |
| Transitions | warning | Occasionally fine |
| Terminology | warning | May appear in quotes or titles |

## Extensibility

Adopters who need additional terminology rules add a local style:

```ini
BasedOnStyles = YLD, Local
```

```
.vale/styles/Local/Terminology.yml  # project-specific terms
```

The `YLD/Terminology.yml` file serves as a reference template for this pattern.
