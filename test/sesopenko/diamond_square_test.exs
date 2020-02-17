defmodule Sesopenko.DiamondSquareTest do
  alias Sesopenko.DiamondSquare

  @moduledoc """
  Tests DiamondSquare
  """
  use ExUnit.Case
  use ExUnit.Case, async: true

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
end
