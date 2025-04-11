defmodule Random do
  def float() do
    :rand.uniform()
  end

  def float(min, max) do
    min + (max - min) * Random.float()
  end

  def vec3() do
    V.new(Random.float(), Random.float(), Random.float())
  end

  def vec3(min, max) do
    V.new(Random.float(min, max), Random.float(min, max), Random.float(min, max))
  end

  def unit_vector() do
    v = Random.vec3(-1, 1)
    length_squared = V.length_squared(v)

    if 1.0e-160 <= length_squared && length_squared <= 1 do
      V.div(v, :math.sqrt(length_squared))
    else
      unit_vector()
    end
  end

  def random_on_hemisphere(normal) do
    on_unit_sphere = Random.unit_vector()

    if V.dot(on_unit_sphere, normal) > 0.0 do
      on_unit_sphere
    else
      V.neg(on_unit_sphere)
    end
  end
end
