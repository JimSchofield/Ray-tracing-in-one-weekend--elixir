defmodule Color do
  def new(r, g, b) do
    V.new(r, g, b)
  end

  def write_color(vec) do
    intensity = Interval.new(0.0, 0.999)

    color = vec
      |> Interval.clamp(intensity)
      |> V.k(255.0)
      |> V.map(fn x -> trunc(x) end)

    "#{color}\n"
  end
end
