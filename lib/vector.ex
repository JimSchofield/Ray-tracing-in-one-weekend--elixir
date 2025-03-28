defmodule V do
  @moduledoc """
  V - Vector module for working with 3-Vectors
  """

  def new(x, y, z) do
    [x, y, z]
  end

  def x([x, _y, _z]) do
    x
  end

  def y([_x, y, _z]) do
    y
  end

  def z([_x, _y, z]) do
    z
  end

  def dot([x1, y1, z1], [x2, y2, z2]) do
    x1 * x2 + y1 * y2 + z1 * z2
  end

  def neg([x, y, z]) do
    [-x, -y, -z]
  end

  def add([x1, y1, z1], [x2, y2, z2]) do
    [x1 + x2, y1 + y2, z1 + z2]
  end

  def sub([x1, y1, z1], [x2, y2, z2]) do
    [x1 - x2, y1 - y2, z1 - z2]
  end

  def mult([x1, y1, z1], [x2, y2, z2]) do
    [x1 * x2, y1 * y2, z1 * z2]
  end

  def k([x1, y1, z1], k) do
    [x1 * k, y1 * k, z1 * k]
  end

  def k(k, [x1, y1, z1]) do
    [x1 * k, y1 * k, z1 * k]
  end

  def div([x, y, z], k) do
    [x / k, y / k, z / k]
  end

  def length_squared(v) do
    V.dot(v, v)
  end

  def length(v) do
    :math.sqrt(V.length_squared(v))
  end

  def to_string([x, y, z]) do
    "#{trunc(x)} #{trunc(y)} #{trunc(z)}"
  end

  def make_unit(v) do
    V.div(v, V.length(v))
  end

  def cross([x1, y1, z1], [x2, y2, z2]) do
    [y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2]
  end
end
