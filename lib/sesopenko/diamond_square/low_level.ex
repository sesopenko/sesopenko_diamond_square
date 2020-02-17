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

  def average_points(grid, points) do
    sum =
      Enum.reduce(points, 0, fn {x, y}, acc ->
        acc + grid[{x, y}]
      end)

    sum / length(points)
  end

  def get_scalar(n, iteration) do
    round(:math.pow(2, n - iteration))
  end

  def get_feeding_points_for_diamond(n, iteration, {target_x, target_y}) do
    # there should be 4 points

    section_scalar = get_scalar(n, iteration)
    midpoint_translation = div(section_scalar, 2)

    [
      {-midpoint_translation + target_x, -midpoint_translation + target_y},
      {midpoint_translation + target_x, -midpoint_translation + target_y},
      {-midpoint_translation + target_x, midpoint_translation + target_y},
      {midpoint_translation + target_x, midpoint_translation + target_y}
    ]
  end

  def get_feeding_points_for_square(n, iteration, {x, y}) do
    section_scalar = round(:math.pow(2, n - iteration))
    midpoint_translation = div(section_scalar, 2)
    midpoint_translation_wrap = midpoint_translation + 1

    size = calc_size(n)
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

  def gen_noise(n, i, max_scale \\ 128.0) do
    ratio = i / n
    range = round((1.0 - ratio) * max_scale)
    :rand.uniform(range) - div(round(range), 2)
  end
end
