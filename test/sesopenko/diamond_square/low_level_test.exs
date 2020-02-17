defmodule Sesopenko.DiamondSquare.LowLevelTest do
  @moduledoc """
  Confirms the behaviour of low level functionality.
  """
  alias Sesopenko.DiamondSquare.LowLevel
  use ExUnit.Case

  describe "wrap_i" do
    wrap_i_scenarios = [
      %{
        :label => "zero",
        :input_value => 0,
        :input_ceiling => 5,
        :expected => 0
      },
      %{
        :label => "non zero, positive, within bounds",
        :input_value => 2,
        :input_ceiling => 5,
        :expected => 2
      },
      %{
        :label => "non zero, positive, equal to ceiling",
        :input_value => 5,
        :input_ceiling => 5,
        :expected => 0
      },
      %{
        :label => "non zero, positive, out of bounds",
        :input_value => 6,
        :input_ceiling => 5,
        :expected => 1
      },
      %{
        :label => "negative, within bounds in negative direction",
        :input_value => -1,
        :input_ceiling => 5,
        :expected => 4
      },
      %{
        :label => "negative, equal to ceiling in negative direction",
        :input_value => -5,
        :input_ceiling => 5,
        :expected => 0
      },
      %{
        :label => "negative, out of bounds in negative direction",
        :input_value => -6,
        :input_ceiling => 5,
        :expected => 4
      }
    ]

    for scenario <- wrap_i_scenarios do
      @tag input_value: scenario[:input_value]
      @tag input_ceiling: scenario[:input_ceiling]
      @tag expected: scenario[:expected]
      test "wrap_i scenario: #{scenario[:label]}", context do
        result = LowLevel.wrap_i(context[:input_value], context[:input_ceiling])
        assert result == context[:expected]
      end
    end
  end

  describe "initailize_grid" do
    scenarios = [
      %{
        :label => "size 2",
        :n => 2,
        :expected_corners => [
          {0, 0},
          {4, 0},
          {4, 4},
          {0, 4}
        ]
      }
    ]

    for scenario <- scenarios do
      @tag n: scenario[:n]
      @tag expected_corners: scenario[:expected_corners]
      test scenario[:label], context do
        grid_result = LowLevel.initialize_grid(context[:n])
        assert length(Map.keys(grid_result)) == 4

        for expected_corner <- context[:expected_corners] do
          Map.has_key?(grid_result, expected_corner)
          assert is_integer(grid_result[expected_corner])
        end
      end
    end
  end

  describe "calc_size" do
    scenarios = [
      %{
        :label => "one",
        :input => 1,
        :expected => 3
      },
      %{
        :label => "two",
        :input => 2,
        :expected => 5
      },
      %{
        :label => "three",
        :input => 3,
        :expected => 9
      },
      %{
        :label => "very large",
        :input => 32,
        :expected => 4_294_967_297
      }
    ]

    for scenario <- scenarios do
      @tag input: scenario[:input]
      @tag expected: scenario[:expected]
      test "calc_size scenario: #{scenario[:label]}", context do
        result = LowLevel.calc_size(context[:input])
        assert result == context[:expected]
      end
    end
  end

  describe "average_points" do
    scenarios = [
      %{
        :label => "one point",
        :grid => %{
          {0, 0} => 5
        },
        :points => [
          {0, 0}
        ],
        :expected_result => 5
      },
      %{
        :label => "two points",
        :grid => %{
          {0, 0} => 10,
          {1, 1} => 20
        },
        :points => [
          {0, 0},
          {1, 1}
        ],
        :expected_result => 15
      }
    ]

    for scenario <- scenarios do
      @tag grid: scenario[:grid]
      @tag points: scenario[:points]
      @tag expected_result: scenario[:expected_result]
      test scenario[:label], context do
        average_result = LowLevel.average_points(context[:grid], context[:points])
        assert context[:expected_result] == average_result, "expected == average"
      end
    end
  end

  describe "get_feeding_points_for_diamond" do
    # diamond points will never have to be wrapped from opposite ends of
    # the grid & are more straight forward to calculate than squares.
    scenarios = [
      # see documentation/diamond-square-2n.svg
      %{
        :label => "n = 2, first iteration, diamond midpoint in center",
        :n => 2,
        :iteration => 0,
        :mid_point => {2, 2},
        :expected_points => [
          {0, 0},
          {4, 0},
          {0, 4},
          {4, 4}
        ]
      },
      %{
        :label => "n = 2, 2nd iteration, diamond midpoint in top left",
        :n => 2,
        :iteration => 1,
        :mid_point => {1, 1},
        :expected_points => [
          {0, 0},
          {2, 0},
          {0, 2},
          {2, 2}
        ]
      },
      %{
        :label => "n = 2, 2nd iteration, diamond midpoint in top right",
        :n => 2,
        :iteration => 1,
        :mid_point => {3, 1},
        :expected_points => [
          {2, 0},
          {4, 0},
          {2, 2},
          {4, 2}
        ]
      },
      # see apps/diamond_square/documentation/explanation/README.md
      %{
        :label => "n = 3, 1st iteration, diamond in the center",
        :n => 3,
        :iteration => 0,
        :mid_point => {4, 4},
        :expected_points => [
          {0, 0},
          {8, 0},
          {0, 8},
          {8, 8}
        ]
      },
      %{
        :label => "n = 3, 2nd iteration, diamond in the lower left",
        :n => 3,
        :iteration => 1,
        :mid_point => {2, 6},
        :expected_points => [
          {0, 4},
          {4, 4},
          {0, 8},
          {4, 8}
        ]
      },
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . f . f . . . .] f(2,4), f(4,4)
      # [. . . m . . . . .] m(3,5)
      # [. . f . f . . . .] f(2,6), f(4,6)
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      %{
        :label => "n = 3, final (3rd) iteration, 2nd from left, 3rd from top",
        :n => 3,
        :iteration => 2,
        :mid_point => {3, 5},
        :expected_points => [
          {2, 4},
          {4, 4},
          {2, 6},
          {4, 6}
        ]
      }
    ]

    for scenario <- scenarios do
      @tag n: scenario[:n]
      @tag iteration: scenario[:iteration]
      @tag mid_point: scenario[:mid_point]
      @tag expected_points: scenario[:expected_points]
      test scenario[:label], context do
        result =
          LowLevel.get_feeding_points_for_diamond(
            context[:n],
            context[:iteration],
            context[:mid_point]
          )

        assert length(result) == 4

        for expected <- context[:expected_points] do
          assert Enum.member?(result, expected), "Should find expected point"
        end
      end
    end
  end
end
