defmodule IntervalTest do
  use ExUnit.Case
  doctest Interval

  test "clamp" do
    int = %Interval{min: 3, max: 7}

    assert Interval.clamp(int, 1) == 3
    assert Interval.clamp(int, 3) == 3
    assert Interval.clamp(int, 4) == 4 
    assert Interval.clamp(int, 5) == 5
    assert Interval.clamp(int, 7) == 7 
    assert Interval.clamp(int, 9) == 7
  end
end
