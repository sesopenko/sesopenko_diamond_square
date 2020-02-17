defmodule Sesopenko.DiamondSquare.LowLevel do
  def calc_size(n) do
    round(:math.pow(2, n)) + 1
  end

  def initialize_grid(n) do
    grid = %{}
    size = calc_size(n)
    end_index = size - 1

    corners = [
      {0, 0},
      {0, end_index},
      {end_index, end_index},
      {end_index, 0}
    ]

    set_corners(grid, corners)
  end

  defp set_corners(grid, corners) when length(corners) > 0 do
    [corner | leftover] = corners
    set_corners(Map.put(grid, corner, :rand.uniform(254)), leftover)
  end

  defp set_corners(grid, _) do
    grid
  end

  def wrap_i(value, max) when value >= 0 and value <= max - 1 do
    value
  end

  def wrap_i(value, max) when value < 0 and value < -max do
    # clean it up so that it's not as large of a negative scaler
    wrap_i(rem(value, max), max)
  end

  def wrap_i(value, max) when value < 0 and value >= -max do
    max + value
  end

  def wrap_i(value, max) do
    rem(value, max)
  end

  def average_points(grid, points) when length(points) > 0 do
    sum =
      Enum.reduce(points, 0, fn {x, y}, acc ->
        acc + grid[{x, y}]
      end)

    sum / length(points)
  end
end
