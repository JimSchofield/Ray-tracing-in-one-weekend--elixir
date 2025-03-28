defmodule RayTrace do
  @moduledoc """
  Ray tracer written in Elixir
  from [Ray tracing in one weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html)
  """

  def main do
    image_width = 256
    image_height = 256

    header = """
    P3
    #{image_width} #{image_height}
    255
    """

    result =
      Enum.reduce(0..(image_height-1), "", fn j, jacc ->
        IO.puts("Rendering row #{j}")
        jacc <> Enum.reduce(0..(image_width-1), "", fn i, iacc ->
            r = i / (image_width - 1)
            g = j / (image_height - 1)
            b = 0.0

            ir = trunc(r * 255)
            ig = trunc(g * 255)
            ib = trunc(b * 255)

            pixel = "#{ir} #{ig} #{ib}\n"

          # pixel <> iacc
          iacc <> pixel
        end)
      end)

    file = header <> result

    File.write("./test.ppm", file)
    IO.puts("Done")
  end
end
