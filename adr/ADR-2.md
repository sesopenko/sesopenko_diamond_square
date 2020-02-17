# ADR-2 Remove GenServer

Refactoring the `Sesopenko.DiamondSquare` module is tricky because of the GenServer responsibility which needs to be maintained. It's easier to alter the interface of the DiamondSquare module without this requirement.

## Decision

We will remove the GenServer requirement from the diamond square fractal generator, making it only responsible for updating its own state.

## Status

Accepted

## Consequences

Describe the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences but all of them affect the team and project in the future.