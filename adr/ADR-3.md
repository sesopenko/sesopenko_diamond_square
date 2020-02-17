# ADR-3 Move low level functions to sub-module

The low level functions of the DiamondSquare module are confusing the interface. The tests are quite cluttered and it would take a lot of work to document all of the low level functions for public usage. Exposing them can result in misuse & unexpected results.

### Example usage:

```elixir
# wikipedia example of n = 2
# https://en.wikipedia.org/wiki/Diamond-square_algorithm
n = 2
diamond_square = Sesopenko.DiamondSquare.new(n)
finished = Sesopenko.DiamondSquare.step_to_end(diamond_square)
grid = finished.grid
IO.inspect(grid, label: "finished grid")
```

## Decision

We will move the low level functionality which is not pertinant to creating a DiamondSquare structure and stepping through it into a submodule and exclude it from hexdocs.

## Status

Accepted

## Consequences

Describe the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences but all of them affect the team and project in the future.

* Moving all of the low level functionality has made it clear that there's nothing testing the full process.
* Premature optimization by using Streams resulted in integrated low level functions failing. Discovered opportunities for performance improvements but the complexity is high & should be done strategically.