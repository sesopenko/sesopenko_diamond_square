defmodule Sesopenko.DiamondSquare.LowLevel do
  def calc_size(n) do
    round(:math.pow(2, n)) + 1
  end
end
