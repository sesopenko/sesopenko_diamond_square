defmodule Sesopenko.DiamondSquare do
  @moduledoc """
  Generates a fractal map grid using the Diamond Square Algorithm.

  ```elixir
  # Initialize an instance
  my_diamond_square = Sesopenko.DiamondSquare.init(n)
  # advance:
  Sesopenko.DiamondSquare.perform_step(my_diamond_square)
  ```
  """
  alias Sesopenko.DiamondSquare.LowLevel
  alias Sesopenko.DiamondSquare
  defstruct grid: %{}, n: nil, i: nil, next_step: nil, size: 0

  @doc """
  Initializes a DiamondSquare with starting values for a given n.

  Returns `{:ok, %Sesopenko.DiamondSquare}
  """
  def init(n) when n > 1 do
    %DiamondSquare{
      grid: LowLevel.initialize_grid(n),
      n: n,
      i: 0,
      next_step: :diamond,
      size: LowLevel.calc_size(n)
    }
  end

  @doc """
  Advances a given diamond square.
  """
  def perform_step(%DiamondSquare{} = diamond_square) do
    current_i = diamond_square.i
    next_step = diamond_square.next_step
    grid = diamond_square.grid
    n = diamond_square.n

    cond do
      next_step == :done ->
        {:ok, diamond_square}

      next_step == :diamond ->
        {
          :ok,
          Map.put(diamond_square, :next_step, :square)
          |> Map.put(:grid, apply_diamond(n, current_i, grid))
        }

      next_step == :square ->
        {
          :ok,
          Map.put(
            diamond_square,
            :next_step,
            get_next_step_after_square_performed(diamond_square)
          )
          |> Map.put(:i, current_i + 1)
          |> Map.put(:grid, apply_square(n, current_i, grid))
        }
    end
  end

  defp get_next_step_after_square_performed(diamond_square) do
    advanced_iteration = diamond_square.i + 1
    n = diamond_square.n

    cond do
      advanced_iteration < n -> :diamond
      advanced_iteration == n -> :done
    end
  end

  defp apply_diamond(n, i, grid) do
    new_grid =
      Enum.reduce(LowLevel.gen_diamond_points(n, i), grid, fn point, current_grid ->
        feeding_points = LowLevel.get_feeding_points_for_diamond(n, i, point)
        average = LowLevel.average_points(grid, feeding_points) + LowLevel.gen_noise(n, i)
        Map.put(current_grid, point, average)
      end)

    new_grid
  end

  defp apply_square(n, i, grid) do
    square_points = LowLevel.gen_square_points(n, i)

    new_grid =
      Enum.reduce(square_points, grid, fn point, current_grid ->
        feeding_points = LowLevel.get_feeding_points_for_square(n, i, point)
        average = LowLevel.average_points(current_grid, feeding_points) + LowLevel.gen_noise(n, i)
        Map.put(current_grid, point, average)
      end)

    new_grid
  end
end
