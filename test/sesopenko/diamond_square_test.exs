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
        {:ok, result} = DiamondSquare.init(context[:n])
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
end
