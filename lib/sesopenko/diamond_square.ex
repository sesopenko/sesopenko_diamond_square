defmodule Sesopenko.DiamondSquare do
  @moduledoc """
  Documentation for DiamondSquare.
  """
  alias Sesopenko.DiamondSquare.LowLevel
  defstruct grid: %{}, n: nil, i: nil, next_step: nil, size: 0

  def step_to_end(diamond_square) do
    n = diamond_square.n
    i = diamond_square.i
    step_to_end(n, i, perform_step(diamond_square))
  end

  def step_to_end(n, i, diamond_square) when i < n do
    n = diamond_square.n
    i = diamond_square.i
    step_to_end(n, i, perform_step(diamond_square))
  end

  def step_to_end(_, _, diamond_square) do
    diamond_square
  end

  def perform_step(diamond_square) do
    current_i = diamond_square.i
    next_step = diamond_square.next_step
    grid = diamond_square.grid
    n = diamond_square.n

    if next_step == :diamond do
      # diamond step
      update = Map.put(diamond_square, :next_step, :square)
      Map.put(update, :grid, apply_diamond(n, current_i, grid))
    else
      # square step
      # increment
      next_step_set = Map.put(diamond_square, :next_step, :diamond)
      i_incremented = Map.put(next_step_set, :i, current_i + 1)
      new_grid = apply_square(n, current_i, grid)
      Map.put(i_incremented, :grid, new_grid)
    end
  end

  def apply_diamond(n, i, grid) do
    new_grid =
      Enum.reduce(LowLevel.gen_diamond_points(n, i), grid, fn point, current_grid ->
        feeding_points = LowLevel.get_feeding_points_for_diamond(n, i, point)
        average = LowLevel.average_points(grid, feeding_points) + LowLevel.gen_noise(n, i)
        Map.put(current_grid, point, average)
      end)

    new_grid
  end

  def apply_square(n, i, grid) do
    square_points = LowLevel.gen_square_points(n, i)

    new_grid =
      Enum.reduce(square_points, grid, fn point, current_grid ->
        feeding_points = get_feeding_points_for_square(n, i, point)
        average = LowLevel.average_points(current_grid, feeding_points) + LowLevel.gen_noise(n, i)
        Map.put(current_grid, point, average)
      end)

    new_grid
  end

  def get_feeding_points_for_square(n, iteration, {x, y}) do
    section_scalar = round(:math.pow(2, n - iteration))
    midpoint_translation = div(section_scalar, 2)
    midpoint_translation_wrap = midpoint_translation + 1

    size = LowLevel.calc_size(n)
    max = size - 1
    min = 0

    translation_vectors = [
      # upwards
      {0, if(y == min, do: -midpoint_translation_wrap, else: -midpoint_translation)},
      # left
      {if(x == min, do: -midpoint_translation_wrap, else: -midpoint_translation), 0},
      # right
      {if(x == max, do: midpoint_translation_wrap, else: midpoint_translation), 0},
      # downards
      {0, if(y == max, do: midpoint_translation_wrap, else: midpoint_translation)}
    ]

    Enum.map(translation_vectors, fn {trans_x, trans_y} ->
      before_wrap = {trans_x + x, trans_y + y}
      {before_x, before_y} = before_wrap
      after_wrap = {LowLevel.wrap_i(before_x, size), LowLevel.wrap_i(before_y, size)}
      after_wrap
    end)
  end
end
