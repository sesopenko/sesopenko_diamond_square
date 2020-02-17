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
      },
      %{
        label: "n(2), step 4 (final), last of square points",
        input_diamond_square: %DiamondSquare{
          n: 2,
          i: 1,
          next_step: :square,
          size: 5,
          grid: %{
            # top row points
            {0, 0} => 20,
            {2, 0} => 20,
            {4, 0} => 20,
            # 2nd row, diamonds
            {1, 1} => 20,
            {3, 1} => 20,
            # middle row points
            {0, 2} => 20,
            {2, 2} => 20,
            {4, 2} => 20,
            # 3rd row, diamonds
            {1, 3} => 20,
            {3, 3} => 20,
            # bottom row points
            {0, 4} => 20,
            {2, 4} => 20,
            {4, 4} => 20
          }
        },
        expected_next_step: :done,
        expected_i: 2,
        expected_grid_points: [
          # top row points
          {0, 0},
          {1, 0},
          {2, 0},
          {3, 0},
          {4, 0},
          # 2nd row
          {0, 1},
          {1, 1},
          {2, 1},
          {3, 1},
          {4, 1},
          # middle row points
          {0, 2},
          {1, 2},
          {2, 2},
          {3, 2},
          {4, 2},
          # 3rd row
          {0, 3},
          {1, 3},
          {2, 3},
          {3, 3},
          {4, 3},
          # bottom row points
          {0, 4},
          {1, 4},
          {2, 4},
          {3, 4},
          {4, 4}
        ]
      },
      %{
        label: "n(2), already complete, trying to step further",
        input_diamond_square: %DiamondSquare{
          n: 2,
          i: 2,
          next_step: :done,
          size: 5,
          grid: %{
            {0, 0} => 20,
            {1, 0} => 20,
            {2, 0} => 20,
            {3, 0} => 20,
            {4, 0} => 20,
            # 2nd row
            {0, 1} => 20,
            {1, 1} => 20,
            {2, 1} => 20,
            {3, 1} => 20,
            {4, 1} => 20,
            # middle row points
            {0, 2} => 20,
            {1, 2} => 20,
            {2, 2} => 20,
            {3, 2} => 20,
            {4, 2} => 20,
            # 3rd row
            {0, 3} => 20,
            {1, 3} => 20,
            {2, 3} => 20,
            {3, 3} => 20,
            {4, 3} => 20,
            # bottom row points
            {0, 4} => 20,
            {1, 4} => 20,
            {2, 4} => 20,
            {3, 4} => 20,
            {4, 4} => 20
          }
        },
        expected_next_step: :done,
        expected_i: 2,
        expected_grid_points: [
          # top row points
          {0, 0},
          {1, 0},
          {2, 0},
          {3, 0},
          {4, 0},
          # 2nd row
          {0, 1},
          {1, 1},
          {2, 1},
          {3, 1},
          {4, 1},
          # middle row points
          {0, 2},
          {1, 2},
          {2, 2},
          {3, 2},
          {4, 2},
          # 3rd row
          {0, 3},
          {1, 3},
          {2, 3},
          {3, 3},
          {4, 3},
          # bottom row points
          {0, 4},
          {1, 4},
          {2, 4},
          {3, 4},
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

  describe "step_to_end" do
    scenarios = [
      %{
        label: "n(2)",
        n: 2,
        expected_next_step: :done,
        expected_i: 2,
        expected_grid_points: [
          # top row points
          {0, 0},
          {1, 0},
          {2, 0},
          {3, 0},
          {4, 0},
          # 2nd row
          {0, 1},
          {1, 1},
          {2, 1},
          {3, 1},
          {4, 1},
          # middle row points
          {0, 2},
          {1, 2},
          {2, 2},
          {3, 2},
          {4, 2},
          # 3rd row
          {0, 3},
          {1, 3},
          {2, 3},
          {3, 3},
          {4, 3},
          # bottom row points
          {0, 4},
          {1, 4},
          {2, 4},
          {3, 4},
          {4, 4}
        ]
      },
      %{
        label: "n(3)",
        n: 3,
        expected_next_step: :done,
        expected_i: 3,
        expected_grid_points: [
          # row 1
          {0, 0},
          {1, 0},
          {2, 0},
          {3, 0},
          {4, 0},
          {5, 0},
          {6, 0},
          {7, 0},
          {8, 0},
          # row 2
          {0, 1},
          {1, 1},
          {2, 1},
          {3, 1},
          {4, 1},
          {5, 1},
          {6, 1},
          {7, 1},
          {8, 1},
          # row 3
          {0, 2},
          {1, 2},
          {2, 2},
          {3, 2},
          {4, 2},
          {5, 2},
          {6, 2},
          {7, 2},
          {8, 2},
          # row 4
          {0, 3},
          {1, 3},
          {2, 3},
          {3, 3},
          {4, 3},
          {5, 3},
          {6, 3},
          {7, 3},
          {8, 3},
          # row 5
          {0, 4},
          {1, 4},
          {2, 4},
          {3, 4},
          {4, 4},
          {5, 4},
          {6, 4},
          {7, 4},
          {8, 4},
          # row 6
          {0, 5},
          {1, 5},
          {2, 5},
          {3, 5},
          {4, 5},
          {5, 5},
          {6, 5},
          {7, 5},
          {8, 5},
          # row 7
          {0, 6},
          {1, 6},
          {2, 6},
          {3, 6},
          {4, 6},
          {5, 6},
          {6, 6},
          {7, 6},
          {8, 6},
          # row 8
          {0, 7},
          {1, 7},
          {2, 7},
          {3, 7},
          {4, 7},
          {5, 7},
          {6, 7},
          {7, 7},
          {8, 7},
          # row 9
          {0, 8},
          {1, 8},
          {2, 8},
          {3, 8},
          {4, 8},
          {5, 8},
          {6, 8},
          {7, 8},
          {8, 8}
        ]
      }
    ]

    for scenario <- scenarios do
      @tag n: scenario[:n]
      @tag expected_next_step: scenario[:expected_next_step]
      @tag expected_i: scenario[:expected_i]
      @tag expected_grid_points: scenario[:expected_grid_points]
      test scenario[:label], context do
        # Arrange.
        starting_grid = DiamondSquare.init(context[:n])
        # Act.
        result = DiamondSquare.step_to_end(starting_grid)
        # Assert.
        assert result.i == context[:expected_i]
        assert result.next_step == context[:expected_next_step]

        for expected_point <- context[:expected_grid_points] do
          assert Map.has_key?(result.grid, expected_point)
        end
      end
    end
  end
end
