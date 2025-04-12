defmodule V do
  @moduledoc """
  V - Vector module for working with 3-Vectors
  """

  defstruct x: 0, y: 0, z: 0

  def new(x, y, z) do
    %V{x: x, y: y, z: z}
  end

  def splat(x) do
    V.new(x, x, x)
  end

  def map(%V{x: x, y: y, z: z}, f) do
    V.new(f.(x), f.(y), f.(z))
  end

  def dot(%V{x: x1, y: y1, z: z1}, %V{x: x2, y: y2, z: z2}) do
    x1 * x2 + y1 * y2 + z1 * z2
  end

  def neg(%V{x: x, y: y, z: z}) do
    new(-x, -y, -z)
  end

  def add(%V{} = left, %V{} = right) do
    new(left.x + right.x, left.y + right.y, left.z + right.z)
  end

  def sub(%V{} = left, %V{} = right) do
    new(left.x - right.x, left.y - right.y, left.z - right.z)
  end

  def mult(%V{} = left, %V{} = right) do
    new(left.x * right.x, left.y * right.y, left.z * right.z)
  end

  def k(%V{x: x1, y: y1, z: z1}, k) do
    new(x1 * k, y1 * k, z1 * k)
  end

  def k(k, %V{x: x1, y: y1, z: z1}) do
    new(x1 * k, y1 * k, z1 * k)
  end

  def div(%V{x: x, y: y, z: z}, k) do
    new(x / k, y / k, z / k)
  end

  def length_squared(v) do
    dot(v, v)
  end

  def length(v) do
    v
    |> length_squared
    |> :math.sqrt()
  end

  def make_unit(v) do
    V.div(v, V.length(v))
  end

  def cross(%V{x: x1, y: y1, z: z1}, %V{x: x2, y: y2, z: z2}) do
    new(y1 * z2 - z1 * y2, z1 * x2 - x1 * z2, x1 * y2 - y1 * x2)
  end

  def near_zero(%V{x: x, y: y, z: z}) do
    s = 1.0e-8

    abs(x) < s && abs(y) < s && abs(z) < s
  end

  def reflect(v, n) do
    V.sub(v, V.k(2 * V.dot(v,n), n))
  end
end

defimpl String.Chars, for: V do
  def to_string(%V{x: x, y: y, z: z}) do
    "#{trunc(x)} #{trunc(y)} #{trunc(z)}"
  end
end

defimpl Inspect, for: V do
  import Inspect.Algebra

  def inspect(vec, opts) do
    concat(["#V<", to_doc([x: vec.x, y: vec.y, z: vec.z], opts), ">"])
  end
end
