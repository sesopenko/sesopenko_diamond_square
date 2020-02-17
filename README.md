# Sesopenko

Generates a plasma fractal grid of points using the [Diamond Square algorithm](https://en.wikipedia.org/wiki/Diamond-square_algorithm).

From [Wikipedia](https://en.wikipedia.org/wiki/Diamond-square_algorithm):

> The diamond-square algorithm is a method for generating [heightmaps](https://en.wikipedia.org/wiki/Heightmap) for computer graphics. It is a slightly better algorithm than the three-dimensional implementation of the midpoint displacement algorithm which produces two-dimensional landscapes. It is also known as the random midpoint displacement fractal, the cloud fractal or the plasma fractal, because of the plasma effect produced when applied.


Starting with 4 corner points of random values, the algorithm fills in the grid, recursively, filling in detail iteratively.  Each step references points from the previous step, adding a small amount of noise, reducing the noise at each iteration.

This results in a grid height-map which resembles mountainous terrain.

![Example output image of diamond square algorithm](documentation/PlasmafractalExample.gif?raw=true "Example output image of diamond square algorithm")

The grid is defined using an `n` iteration value and the size of the grid equals `2^n + 1`.

## Installation

If [available in Hex](https://hex.pm/packages/sesopenko_diamond_square), the package can be installed
by adding `sesopenko_diamond_square` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sesopenko_diamond_square, "~> 1.0.0"}
  ]
end
```

## Documentation

Documentation can be found at [https://hexdocs.pm/sesopenko_diamond_square/api-reference.html](https://hexdocs.pm/sesopenko_diamond_square/api-reference.html).

## Example Usage

Example of manually stepping through the algorithm:

```elixir
my_diamond_square = Sesopenko.DiamondSquare.init(n)
{:ok, new_state} = Sesopenko.DiamondSquare.perform_step(my_diamond_square)
IO.puts(new_state.grid)
IO.puts(new_state.size)
```

Example of stepping to the end:

```elixir
my_diamond_square = Sesopenko.DiamondSquare.init(n)
complete = Sesopenko.DiamondSquare.step_to_end(my_diamond_square)
IO.puts(new_state.grid)
IO.puts(new_state.size)
```

## License

This is licensed [GNU GPL V3](LICENSE.txt).  A copy of the license should be included in any distributions of this project.  If not, an [online copy of the GNU GPL V3 License](https://www.gnu.org/licenses/gpl-3.0.en.html) may be referenced.