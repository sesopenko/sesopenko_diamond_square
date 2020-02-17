defmodule Sesopenko.DiamondSquare.LowLevelTest do
  @moduledoc """
  Confirms the behaviour of low level functionality.
  """
  alias Sesopenko.DiamondSquare.LowLevel
  use ExUnit.Case

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
end
