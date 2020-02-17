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
end
