defmodule Interval do
  defstruct [:max, :min]

  def new(min, max) do
    %Interval{min: min, max: max}
  end

  def contains(num, int) do
    int.min <= num && num <= int.max
  end

  def surrounds(num, int) do
    int.min < num && num < int.max
  end

  def clamp(%V{} = vec, %Interval{} = int) do
    V.map(vec, fn n -> clamp(n, int) end)
  end

  def clamp(x, %Interval{min: min, max: max}) do
    case x do
      x when x < min -> min
      x when x > max -> max
      _ -> x
    end
  end
end
