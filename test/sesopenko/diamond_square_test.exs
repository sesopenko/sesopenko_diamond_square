defmodule Sesopenko.DiamondSquareTest do
  alias Sesopenko.DiamondSquare

  @moduledoc """
  Tests DiamondSquare
  """
  use ExUnit.Case
  use ExUnit.Case, async: true

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
        average_result = DiamondSquare.average_points(context[:grid], context[:points])
        assert context[:expected_result] == average_result, "expected == average"
      end
    end
  end

  describe "gen_diamond_span_list" do
    # We can use a list of positions a 1 dimensional axis for both x and y
    # and the list can be generated for a given n and iteration.
    # This is invaluable for calculating all of the diamond points across the grid,
    # for each axis.
    scenarios = [
      %{
        :label => "List diamond points for n = 2 grid, first pass",
        :n => 2,
        :iteration => 0,
        :expected_point_count => 1,
        :expected_list => [2]
      },
      %{
        :label => "List diamond points for n = 2 grid, second pass",
        :n => 2,
        :iteration => 1,
        :expected_point_count => 2,
        :expected_list => [1, 3]
      },
      %{
        :label => "List diamond points for n = 3 grid, 1st pass",
        :n => 3,
        :iteration => 0,
        :expected_point_count => 1,
        :expected_list => [4]
      },
      %{
        :label => "List diamond points for n = 3 grid, 2nd pass",
        :n => 3,
        :iteration => 1,
        :expected_point_count => 1,
        :expected_list => [2, 6]
      },
      %{
        :label => "List diamond points for n = 3 grid, 3rd pass",
        :n => 3,
        :iteration => 2,
        :expected_point_count => 1,
        :expected_list => [1, 3, 5, 7]
      }
    ]

    for scenario <- scenarios do
      @tag n: scenario[:n]
      @tag iteration: scenario[:iteration]
      @tag expected_point_count: scenario[:expected_point_count]
      @tag expected_list: scenario[:expected_list]
      test scenario[:label], context do
        n = context[:n]
        iteration = context[:iteration]
        result = DiamondSquare.gen_diamond_span_list(n, iteration)
        assert Enum.sort(result) == Enum.sort(context[:expected_list])
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
          DiamondSquare.get_feeding_points_for_diamond(
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

  describe "get_feeding_points_for_square" do
    scenarios = [
      %{
        :label => "n2 i0, center, simple",
        :n => 2,
        :iteration => 0,
        :mid_point => {2, 2},
        :expected_points => [
          {2, 0},
          {0, 2},
          {4, 2},
          {2, 4}
        ]
      },
      # [f . x . f] f(0,0), x(2,0), f(4,0)
      # [. . . . .]
      # [. . f . .] f(2,2), f(2,2) (once naturally, once with a wrap around)
      # [. . . . .]
      # [. . . . .]
      %{
        :label => "n2, i0, {2,3} square point",
        :n => 2,
        :iteration => 0,
        :mid_point => {2, 0},
        :expected_points => [
          {2, 2},
          {0, 0},
          {4, 0},
          {2, 2}
        ]
      },
      # wrap around, and consider the receiving point on the topmost
      # position, receiving from below, for the lower point.
      # [. . . . .]
      # [. f . . .] f(1,1)
      # [. . . . .]
      # [. f . . .] f(1,3)
      # [f x f . .] f(0,4), x(1,4), f(2,4)
      %{
        :label => "n2, i1, {1,4} square point",
        :n => 2,
        :iteration => 1,
        :mid_point => {1, 4},
        :expected_points => [
          {1, 3},
          {0, 4},
          {2, 4},
          {1, 1}
        ]
      },
      # wrap around, and consider the receiving point on the topmost
      # position, receiving from below, for the lower point.
      # [. . . . . . . . .]
      # [. f . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. f . . . . . . .]
      # [f x f . . . . . .]
      %{
        :label => "n3, i2, {1,8} square point",
        :n => 3,
        :iteration => 2,
        :mid_point => {1, 8},
        :expected_points => [
          {1, 7},
          {0, 8},
          {2, 8},
          {1, 1}
        ]
      },
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . f . . . .] f(4,4)
      # [. . . . . . . . .]
      # [. . f . x . f . .] f(2,6),x(4,6),f(6,6)
      # [. . . . . . . . .]
      # [. . . . f . . . .] f(4,8)
      %{
        :label => "n3, i1, {4,6} square point",
        :n => 3,
        :iteration => 1,
        :mid_point => {4, 6},
        :expected_points => [
          {4, 4},
          {2, 6},
          {6, 6},
          {4, 8}
        ]
      },
      #   0 1 2 3 4 5 6 7 8
      # 0[. . . . . . . . .]
      # 1[. . . . . . . . .]
      # 2[. . . . . . . . .]
      # 3[. . . . . . . . .]
      # 4[. . . . . . f . .] f{6,4}
      # 5[. . . . . f x f .] f{5,5}, x{6,5), f{7,5}
      # 6[. . . . . . f . .] f{6,6}
      # 7[. . . . . . . . .]
      # 8[. . . . . . . . .]
      %{
        :label => "n3, i2, {6,5} square point",
        :n => 3,
        :iteration => 2,
        :mid_point => {6, 5},
        :expected_points => [
          {6, 4},
          {5, 5},
          {7, 5},
          {6, 6}
        ]
      },
      #   0 1 2 3 4 5 6 7 8
      # 0[. . . . . . . . .]
      # 1[. . . . . f . . .] {5,1}
      # 2[. . . . . . . . .]
      # 3[. . . . . . . . .]
      # 4[. . . . . . . . .]
      # 5[. . . . . . . . .]
      # 6[. . . . . . . . .]
      # 7[. . . . . f . . .] {5,7}
      # 8[. . . . f x f . .] {4,8}, {6,8}
      %{
        :label => "n3, i2, {5,8} square point, expecting wrap",
        :n => 3,
        :iteration => 2,
        :mid_point => {5, 8},
        :expected_points => [
          {5, 7},
          {4, 8},
          {6, 8},
          {5, 1}
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
          DiamondSquare.get_feeding_points_for_square(
            context[:n],
            context[:iteration],
            context[:mid_point]
          )

        assert length(result) == 4
        assert result == context[:expected_points]

        for expected <- context[:expected_points] do
          assert Enum.member?(result, expected), "Should find expected point"
        end
      end
    end
  end

  describe "gen_diamond_points" do
    scenarios = [
      # [. . . . .]
      # [. . . . .]
      # [. . x . .] 2,2
      # [. . . . .]
      # [. . . . .]
      %{
        :label => "n2 i0",
        :n => 2,
        :i => 0,
        :expected_length => 1,
        :expected_result => [
          {2, 2}
        ]
      },
      # [. . . . .]
      # [. x . x .] {1,1}, {3,1}
      # [. . . . .]
      # [. x . x .] {1, 3}, {3,3}
      # [. . . . .]
      %{
        :label => "n2 i1",
        :n => 2,
        :i => 1,
        :expected_length => 4,
        :expected_result => [
          {1, 1},
          {3, 1},
          {1, 3},
          {3, 3}
        ]
      },
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . x . . . .] {4,4}
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      %{
        :label => "n3 i0",
        :n => 3,
        :i => 0,
        :expected_length => 1,
        :expected_result => [
          {4, 4}
        ]
      },
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . x . . . x . .] {2,2}, {6,2}
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . x . . . x . .] {2,6}, {6,6}
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      %{
        :label => "n3 i1",
        :n => 3,
        :i => 1,
        :expected_length => 4,
        :expected_result => [
          {2, 2},
          {6, 2},
          {2, 6},
          {6, 6}
        ]
      }
    ]

    for scenario <- scenarios do
      @tag n: scenario[:n]
      @tag i: scenario[:i]
      @tag expected_length: scenario[:expected_length]
      @tag expected_result: scenario[:expected_result]
      test scenario[:label], context do
        result = DiamondSquare.gen_diamond_points(context[:n], context[:i])
        assert length(result) == context[:expected_length]
        assert result == context[:expected_result]
      end
    end
  end

  describe "gen_square_points" do
    scenarios = [
      #   0 1 2 3 4
      # 0[. . x . .]
      # 1[. . . . .]
      # 2[x . . . x]
      # 3[. . . . .]
      # 4[. . x . .]
      %{
        :label => "n2, i0",
        :n => 2,
        :i => 0,
        :expected => [
          {2, 0},
          {0, 2},
          {4, 2},
          {2, 4}
        ]
      },
      #   0 1 2 3 4
      # 0[. x . x .]
      # 1[x . x . x]
      # 2[. x . x .]
      # 3[x . x . x]
      # 4[. x . x .]
      %{
        :label => "n2, i1",
        :n => 2,
        :i => 1,
        :expected => [
          {1, 0},
          {3, 0},
          {0, 1},
          {2, 1},
          {4, 1},
          {1, 2},
          {3, 2},
          {0, 3},
          {2, 3},
          {4, 3},
          {1, 4},
          {3, 4}
        ]
      },
      # [. . . . 2 . . . .] (4,0)
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [2 . . . . . . . 2] (0,4) (8,4)
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . . . . . .]
      # [. . . . 2 . . . .] (4,8)
      %{
        :label => "n3, i0",
        :n => 3,
        :i => 0,
        :expected => [
          {4, 0},
          {0, 4},
          {8, 4},
          {4, 8}
        ]
      },
      # [. . 4 . . . 4 . .] (2,0) (6,0)
      # [. . . . . . . . .]
      # [4 . . . 4 . . . 4] (0,2) (4,2) (8,2)
      # [. . . . . . . . .]
      # [. . 4 . . . 4 . .] (2,4) (6,4)
      # [. . . . . . . . .]
      # [4 . . . 4 . . . 4] (0,6) (4,6) (8,6)
      # [. . . . . . . . .]
      # [. . 4 . . . 4 . .] (2,8) (6,8)
      %{
        :label => "n3, i1",
        :n => 3,
        :i => 1,
        :expected => [
          {2, 0},
          {6, 0},
          {0, 2},
          {4, 2},
          {8, 2},
          {2, 4},
          {6, 4},
          {0, 6},
          {4, 6},
          {8, 6},
          {2, 8},
          {6, 8}
        ]
      },
      # [. 6 . 6 . 6 . 6 .] (1,0) (3,0) (5,0) (7,0)
      # [6 . 6 . 6 . 6 . 6] (0,1) (2,1) (4,1) (6,1) (8,1)
      # [. 6 . 6 . 6 . 6 .] (1,2) (3,2) (5,2) (7,2)
      # [6 . 6 . 6 . 6 . 6] (0,3) (2,3) (4,3) (6,3) (8,3)
      # [. 6 . 6 . 6 . 6 .] (1,4) (3,4) (5,4) (7,4)
      # [6 . 6 . 6 . 6 . 6] (0,5) (2,5) (4,5) (6,5) (8,5)
      # [. 6 . 6 . 6 . 6 .] (1,6) (3,6) (5,6) (7,6)
      # [6 . 6 . 6 . 6 . 6] (0,7) (2,7) (4,7) (6,7) (8,7)
      # [. 6 . 6 . 6 . 6 .] (1,8) (3,8) (5,8) (7,8)
      %{
        :label => "n3, i2",
        :n => 3,
        :i => 2,
        :expected => [
          {1, 0},
          {3, 0},
          {5, 0},
          {7, 0},
          {0, 1},
          {2, 1},
          {4, 1},
          {6, 1},
          {8, 1},
          {1, 2},
          {3, 2},
          {5, 2},
          {7, 2},
          {0, 3},
          {2, 3},
          {4, 3},
          {6, 3},
          {8, 3},
          {1, 4},
          {3, 4},
          {5, 4},
          {7, 4},
          {0, 5},
          {2, 5},
          {4, 5},
          {6, 5},
          {8, 5},
          {1, 6},
          {3, 6},
          {5, 6},
          {7, 6},
          {0, 7},
          {2, 7},
          {4, 7},
          {6, 7},
          {8, 7},
          {1, 8},
          {3, 8},
          {5, 8},
          {7, 8}
        ]
      }
    ]

    for scenario <- scenarios do
      @tag n: scenario[:n]
      @tag i: scenario[:i]
      @tag expected: scenario[:expected]
      test scenario[:label], context do
        result = DiamondSquare.gen_square_points(context[:n], context[:i])
        assert length(result) == length(context[:expected])
        assert result == context[:expected]
      end
    end
  end
end
