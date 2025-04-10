defmodule VTest do
  use ExUnit.Case
  doctest V

  test "Makes a vector" do
    assert V.new(1, 2, 3) == %V{x: 1, y: 2, z: 3}
  end

  test "Components work" do
    v = V.new(1, 2, 3)
    assert v.x == 1
    assert v.y == 2
    assert v.z == 3
  end

  test "neg - negates a vector" do
    assert V.neg(V.new(-1, 2, 3)) == V.new(1, -2, -3)
  end

  test "Vectors add" do
    assert V.add(V.new(-1, 2, -3), V.new(1, -2, 3)) == V.new(0, 0, 0)
    v = V.new(1, 2, 3)
    w = V.new(3, 2, 1)
    assert V.add(v, w) == V.new(4, 4, 4)
    assert V.add(v, V.neg(v)) == V.new(0, 0, 0)
  end

  test "Vectors subtract" do
    assert V.sub(V.new(-1, 2, -3), V.new(1, -2, 3)) == V.new(-2, 4, -6)
    v = V.new(1, 2, 3)
    w = V.new(3, 2, 1)
    assert V.sub(v, w) == V.new(-2, 0, 2)
    assert V.sub(v, v) == V.new(0, 0, 0)
  end

  test "Vectors multiply by component" do
    v = V.new(1, 2, 3)
    w = V.new(3, 2, 3)
    assert V.mult(v, w) == V.new(3, 4, 9)
  end

  test "Vectors scale both ways" do
    v = V.new(1, 2, 3)
    k = 3
    assert V.k(v, k) == V.new(3, 6, 9)
    assert V.k(k, v) == V.new(3, 6, 9)

    w = V.new(1, 2, 3)
    k2 = -1
    assert V.k(k2, w) == V.new(-1, -2, -3)
    assert V.k(w, k2) == V.new(-1, -2, -3)
  end

  test "Vectors divide by scalar" do
    v = V.new(2, 4, 6)
    assert V.div(v, 2) == V.new(1.0, 2.0, 3.0)
  end

  test "Vector length" do
    v = V.new(1, 2, 2)
    assert V.length(v) == 3.0
    w = V.new(2, 10, 11)
    assert V.length(w) == 15.0
  end

  test "Vector prints" do
    v = V.new(1, 2, 2)
    assert "#{V.div(v, 2)}" == "0 1 1"
  end

  test "Find unit vector" do
    v = V.new(1, 2, 2)
    assert V.make_unit(v) == V.new(1 / 3, 2 / 3, 2 / 3)
  end

  test "cross product" do
    v = V.new(3, -3, 1)
    w = V.new(4, 9, 2)
    assert V.cross(v, w) == V.new(-15, -2, 39)
  end

  test "cross product 2" do
    v = V.new(3, -3, 1)
    w = V.new(-12, 12, -4)
    assert V.cross(v, w) == V.new(0, 0, 0)
  end
end
