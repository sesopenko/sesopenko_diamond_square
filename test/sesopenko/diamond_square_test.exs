defmodule Sesopenko.DiamondSquareTest do
  alias Sesopenko.DiamondSquare

  @moduledoc """
  Tests DiamondSquare
  """
  use ExUnit.Case
  use ExUnit.Case, async: true

  describe "init/1" do
    scenarios = [
      %{
        n: 2,
        expected_points: [
          {0, 0},
          {4, 0},
          {0, 4},
          {4, 4}
        ],
        expected_size: 5,
        expected_i: 0,
        expected_next_step: :diamond
      }
    ]

    for scenario <- scenarios do
      @tag n: scenario[:n]
      @tag expected_points: scenario[:expected_points]
      @tag expected_size: scenario[:expected_size]
      @tag expected_i: scenario[:expected_i]
      @tag expected_next_step: scenario[:expected_next_step]
      test "#{scenario[:n]}", context do
        # Arrange.
        expected_points = context[:expected_points]
        expected_size = context[:expected_size]
        expected_i = context[:expected_i]
        expected_next_step = context[:expected_next_step]
        # Act.
        result = DiamondSquare.init(context[:n])
        # Assert.
        assert length(expected_points) == length(Map.keys(result.grid))

        for expected_point <- expected_points do
          assert Map.has_key?(result.grid, expected_point)
        end

        assert result.size == expected_size
        assert result.i == expected_i
        assert result.next_step == expected_next_step
      end
    end
  end

  describe "perform_step" do
    scenarios = [
      %{
        label: "n(2), step 1, setting diamond point in center",
        input_diamond_square: DiamondSquare.init(2),
        expected_next_step: :square,
        expected_i: 0,
        expected_grid_points: [
          {0, 0},
          {4, 0},
          {2, 2},
          {0, 4},
          {4, 4}
        ]
      },
      %{
        label: "n(2), step 2, setting square points on edges",
        input_diamond_square: %DiamondSquare{
          n: 2,
          i: 0,
          next_step: :square,
          size: 5,
          grid: %{
            {0, 0} => 20,
            {4, 0} => 20,
            {2, 2} => 20,
            {0, 4} => 20,
            {4, 4} => 20
          }
        },
        expected_next_step: :diamond,
        expected_i: 1,
        expected_grid_points: [
          {0, 0},
          {2, 0},
          {4, 0},
          {0, 2},
          {2, 2},
          {4, 2},
          {0, 4},
          {2, 4},
          {4, 4}
        ]
      },
      %{
        label: "n(2), step 3, setting four diamond points",
        input_diamond_square: %DiamondSquare{
          n: 2,
          i: 1,
          next_step: :diamond,
          size: 5,
          grid: %{
            {0, 0} => 20,
            {2, 0} => 20,
            {4, 0} => 20,
            {0, 2} => 20,
            {2, 2} => 20,
            {4, 2} => 20,
            {0, 4} => 20,
            {2, 4} => 20,
            {4, 4} => 20
          }
        },
        expected_next_step: :square,
        expected_i: 1,
        expected_grid_points: [
          # top row points
          {0, 0},
          {2, 0},
          {4, 0},
          # 2nd row, diamonds
          {1, 1},
          {3, 1},
          # middle row points
          {0, 2},
          {2, 2},
          {4, 2},
          # 3rd row, diamonds
          {1, 3},
          {3, 1},
          # bottom row points
          {0, 4},
          {2, 4},
          {4, 4}
        ]
      }
    ]

    for scenario <- scenarios do
      @tag input_diamond_square: scenario[:input_diamond_square]
      @tag expected_next_step: scenario[:expected_next_step]
      @tag expected_i: scenario[:expected_i]
      @tag expected_grid_points: scenario[:expected_grid_points]
      test scenario[:label], context do
        # Arrange.
        input_diamond_square = context[:input_diamond_square]
        expected_next_step = context[:expected_next_step]
        expected_i = context[:expected_i]
        expected_grid_points = context[:expected_grid_points]
        # Act.
        {:ok, result} = DiamondSquare.perform_step(input_diamond_square)
        # Assert.
        assert result.i == expected_i
        assert result.next_step == expected_next_step

        for expected_grid_point <- expected_grid_points do
          assert Map.has_key?(result.grid, expected_grid_point)
        end
      end
    end
  end
end
