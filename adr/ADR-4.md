# ADR-4 Need advance to end capability

Stepping through the diamond square algorithm manually, step by step is cumbersome for most usage cases.

## Decision

We will add a `Sesopenko.DiamondSquare.step_to_end(%Sesopenko.DiamondSquare{})` helper function.  It will advance it until the grid is completely full.

## Status

Accepted

## Consequences

Describe the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences but all of them affect the team and project in the future.