defmodule Ray do

  defstruct [:origin, :direction]

  def new(origin, direction) do
    %Ray { origin: origin, direction: direction }
  end

  def at(ray, t) do
    V.add(ray.origin, V.k(ray, t))
  end

end
