defmodule Sesopenko.LineArrayTest do
  alias Sesopenko.LineArray
  alias Sesopenko.DiamondSquare
  use ExUnit.Case
  use ExUnit.Case, async: true

  test "has no values" do
    diamond_square = %DiamondSquare{
      grid: %{},
      size: 5
    }

    expected_dimensions = 5

    line_array = LineArray.from_diamond_square(diamond_square)

    lines = line_array.lines

    assert length(lines) == expected_dimensions

    assert line_array.min == 0
    assert line_array.max == 0

    for scan_line <- lines do
      assert length(scan_line) == expected_dimensions

      for x <- scan_line do
        assert x == 254
      end
    end
  end

  test "has partial values" do
    diamond_square = %DiamondSquare{
      grid: %{
        {0, 0} => 1,
        {1, 0} => 2,
        {0, 1} => 3,
        {1, 1} => 4
      },
      size: 2
    }

    expected_dimensions = 2

    line_array = LineArray.from_diamond_square(diamond_square)

    lines = line_array.lines

    assert length(lines) == expected_dimensions

    assert lines = [
             [1, 2],
             [3, 4]
           ]

    assert line_array.min == 1
    assert line_array.max == 4
  end
end
