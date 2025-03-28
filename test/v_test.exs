defmodule VTest do
  use ExUnit.Case
  doctest V

  test "Makes a vector" do
    assert V.new(1, 2, 3) == [1, 2, 3]
  end

  test "Components work" do
    v = [1, 2, 3]
    assert V.x(v) == 1
    assert V.y(v) == 2
    assert V.z(v) == 3
  end

  test "neg - negates a vector" do
    assert V.neg([-1, 2, -3]) == [1, -2, 3]
  end

  test "Vectors add" do
    assert V.add([-1, 2, -3], [1, -2, 3]) == [0, 0, 0]
    v = V.new(1, 2, 3)
    w = V.new(3, 2, 1)
    assert V.add(v, w) == [4, 4, 4]
    assert V.add(v, V.neg(v)) == [0, 0, 0]
  end

  test "Vectors subtract" do
    assert V.sub([-1, 2, -3], [1, -2, 3]) == [-2, 4, -6]
    v = V.new(1, 2, 3)
    w = V.new(3, 2, 1)
    assert V.sub(v, w) == [-2, 0, 2]
    assert V.sub(v, v) == [0, 0, 0]
  end

  test "Vectors multiply by component" do
    v = V.new(1, 2, 3)
    w = V.new(3, 2, 3)
    assert V.mult(v, w) == [3, 4, 9]
  end

  test "Vectors scale both ways" do
    v = V.new(1, 2, 3)
    k = 3
    assert V.k(v, k) == [3, 6, 9]
    assert V.k(k, v) == [3, 6, 9]

    w = V.new(1, 2, 3)
    k2 = -1
    assert V.k(k2, w) == [-1, -2, -3]
    assert V.k(w, k2) == [-1, -2, -3]
  end

  test "Vectors divide by scalar" do
    v = V.new(2, 4, 6)
    assert V.div(v, 2) == [1.0, 2.0, 3.0]
  end
end
