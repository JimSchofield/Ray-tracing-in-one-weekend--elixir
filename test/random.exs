defmodule RandomTest do
  use ExUnit.Case
  doctest Random

  test "generates different vectors" do

    v = Random.unit_vector()
    w = Random.unit_vector()

    assert v != w

    assert V.length(v) <=1
    assert V.length(w) <=1
  end

  test "Generates unit vectors <= 1" do
    assert V.length(Random.unit_vector()) <= 1
    assert V.length(Random.unit_vector()) <= 1
    assert V.length(Random.unit_vector()) <= 1
    assert V.length(Random.unit_vector()) <= 1
    assert V.length(Random.unit_vector()) <= 1
    assert V.length(Random.unit_vector()) <= 1
    assert V.length(Random.unit_vector()) <= 1
    assert V.length(Random.unit_vector()) <= 1
    assert V.length(Random.unit_vector()) <= 1
  end
end
