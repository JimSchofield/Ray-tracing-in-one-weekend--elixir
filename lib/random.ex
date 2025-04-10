defmodule Random do
  def float() do
    :rand.uniform()
  end

  def float(min, max) do
    min + max * float()
  end

  def vec3() do
    V.new(float(), float(), float())
  end

  def vec3(min, max) do
    V.new(float(min, max), float(min, max), float(min, max))
  end
end
