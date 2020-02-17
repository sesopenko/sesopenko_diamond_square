# ADR-3 Move low level functions to sub-module

The low level functions of the DiamondSquare module are confusing the interface. The tests are quite cluttered and it would take a lot of work to document all of the low level functions for public usage. Exposing them can result in misuse & unexpected results.

## Decision

We will move the low level functionality which is not pertinant to creating a DiamondSquare structure and stepping through it into a submodule and exclude it from hexdocs.

## Status

Proposed

## Consequences

Describe the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences but all of them affect the team and project in the future.