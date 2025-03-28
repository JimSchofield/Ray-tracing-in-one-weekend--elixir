defmodule Color do
  def new(r, g, b) do
    [r, g, b]
  end

  def write_color([r, g, b]) do
    ir = trunc(r * 255)
    ig = trunc(g * 255)
    ib = trunc(b * 255)

    "#{ir} #{ig} #{ib}\n"
  end
end
