defmodule Sesopenko.LineArray do
  alias Sesopenko.LineArray
  defstruct lines: [], min: 0, max: 0

  def from_diamond_square(diamond_square) do
    size = diamond_square.size
    min_dimension = 0
    max_dimension = size - 1
    grid = diamond_square.grid
    values = Map.values(grid)
    min_value = if(length(values) == 0, do: 0, else: Enum.min(values))
    max_value = if(length(values) == 0, do: 0, else: Enum.max(values))

    lines =
      Enum.map(min_dimension..max_dimension, fn y ->
        Enum.map(min_dimension..max_dimension, fn x ->
          Map.get_lazy(grid, {x, y}, fn -> 254 end)
        end)
      end)

    %LineArray{
      lines: lines,
      min: min_value,
      max: max_value
    }
  end
end
