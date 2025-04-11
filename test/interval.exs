defmodule IntervalTest do
  use ExUnit.Case
  doctest Interval

  test "clamp" do
    int = %Interval{min: 3.0, max: 7.0}

    assert Interval.clamp(1.0, int) == 3
    assert Interval.clamp(3.0, int) == 3
    assert Interval.clamp(4.0, int) == 4
    assert Interval.clamp(5.0, int) == 5
    assert Interval.clamp(7.0, int) == 7
    assert Interval.clamp(9.0, int) == 7
  end

  test "clamp (vector)" do
    int = %Interval{min: 3, max: 7}

    vec = V.new(1.0, 4.0, 9.0)
    assert Interval.clamp(vec, int) == V.new(3, 4, 7)

    vec2 = V.new(-3.0, 3.0, 7.0)
    assert Interval.clamp(vec2, int) == V.new(3, 3, 7)

    assert vec2 |> Interval.clamp(int) == V.new(3, 3, 7)
  end
end
