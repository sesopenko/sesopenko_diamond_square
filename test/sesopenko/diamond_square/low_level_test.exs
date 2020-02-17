defmodule Sesopenko.DiamondSquare.LowLevelTest do
  alias Sesopenko.DiamondSquare.LowLevel
  use ExUnit.Case

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
