defmodule Color do
  def new(r, g, b) do
    V.new(r,g,b)
  end

  def write_color(%V{x: r, y: g, z: b}) do
    ir = trunc(r * 255)
    ig = trunc(g * 255)
    ib = trunc(b * 255)

    "#{ir} #{ig} #{ib}\n"
  end
end
