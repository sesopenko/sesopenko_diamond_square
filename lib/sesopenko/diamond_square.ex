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
      Enum.reduce(gen_diamond_points(n, i), grid, fn point, current_grid ->
        feeding_points = get_feeding_points_for_diamond(n, i, point)
        average = average_points(grid, feeding_points) + gen_noise(n, i)
        Map.put(current_grid, point, average)
      end)

    new_grid
  end

  def apply_square(n, i, grid) do
    square_points = gen_square_points(n, i)

    new_grid =
      Enum.reduce(square_points, grid, fn point, current_grid ->
        feeding_points = get_feeding_points_for_square(n, i, point)
        average = average_points(current_grid, feeding_points) + gen_noise(n, i)
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
      after_wrap = {wrap_i(before_x, size), wrap_i(before_y, size)}
      after_wrap
    end)
  end

  def get_feeding_points_for_diamond(n, iteration, {target_x, target_y}) do
    # there should be 4 points

    section_scalar = get_scalar(n, iteration)
    midpoint_translation = div(section_scalar, 2)

    translation_vectors = [
      {-midpoint_translation, -midpoint_translation},
      {midpoint_translation, -midpoint_translation},
      {-midpoint_translation, midpoint_translation},
      {midpoint_translation, midpoint_translation}
    ]

    Enum.map(translation_vectors, fn {translation_x, translation_y} ->
      {translation_x + target_x, translation_y + target_y}
    end)
  end

  @doc """
  Generates a full list of diamond points, spanning a 2 dimensional axis
  """
  def gen_diamond_points(n, i) do
    Enum.flat_map(gen_diamond_span_list(n, i), fn y ->
      Enum.map(gen_diamond_span_list(n, i), fn x ->
        {x, y}
      end)
    end)
  end

  @doc """
  Generates a list of diamond points spanning a 1 dimensional axis
  """
  def gen_diamond_span_list(n, iteration) when n > 1 and iteration < n and iteration >= 0 do
    num_points = round(:math.pow(2, iteration))
    last_point_in_span = num_points - 1

    scalar = get_scalar(n, iteration)
    midpoint_translation = div(scalar, 2)

    Enum.map(0..last_point_in_span, fn i -> i * scalar + midpoint_translation end)
  end

  @doc """
  Generates a full list of square points spanning a 2 dimensional axis
  """
  def gen_square_points(n, i) when n > 1 and i < n and i >= 0 do
    num_rows = round(:math.pow(2, i + 1)) + 1
    end_row = num_rows - 1
    scalar = div(get_scalar(n, i), 2)

    Enum.flat_map(0..end_row, fn row_i ->
      min_qty = round(:math.pow(2, i))
      shift = rem(row_i, 2)
      x_translate = rem(row_i + 1, 2)
      qty = min_qty + shift

      Enum.map(0..(qty - 1), fn column_i ->
        y = row_i * scalar
        x = (column_i + x_translate) * scalar + column_i * scalar
        point = {x, y}
        point
      end)
    end)
  end

  defp get_scalar(n, iteration) do
    round(:math.pow(2, n - iteration))
  end

  def average_points(grid, points) when length(points) > 0 do
    sum =
      Enum.reduce(points, 0, fn {x, y}, acc ->
        acc + grid[{x, y}]
      end)

    sum / length(points)
  end

  def gen_noise(n, i, max_scale \\ 128.0) do
    ratio = i / n
    range = round((1.0 - ratio) * max_scale)
    :rand.uniform(range) - div(round(range), 2)
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
end
