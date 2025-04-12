defmodule Color do
  def new(r, g, b) do
    V.new(r, g, b)
  end

  def linear_to_gamma(num) do
    if num > 0 do
      :math.sqrt(num)
    else
      0
    end
  end

  def write_color(vec) do
    intensity = Interval.new(0.0, 0.999)

    color = vec
      |> V.map(fn x -> linear_to_gamma(x) end)
      |> Interval.clamp(intensity)
      |> V.k(255.0)
      |> V.map(fn x -> trunc(x) end)

    "#{color}\n"
  end
end
