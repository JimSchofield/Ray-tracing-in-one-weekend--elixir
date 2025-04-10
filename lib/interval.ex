defmodule Interval do
  defstruct [:max, :min]

  def new(min, max) do
    %Interval{min: min, max: max}
  end

  def contains(int, num) do
    int.min <= num && num <= int.max
  end

  def surrounds(int, num) do
    int.min < num && num < int.max
  end

  def clamp(%Interval{min: min, max: max}, x) do
    case x do
      x when x < min -> min
      x when x > max -> max
      _ -> x
    end
  end
end
