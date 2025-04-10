defmodule RT do
  @moduledoc """
  Ray tracer written in Elixir
  from [Ray tracing in one weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html)
  """
  def main(_args \\ []) do
    aspect_ratio = 16.0 / 9.0
    image_width = 600

    # World
    world =
      %HittableList{}
      |> HittableList.add(Sphere.new(V.new(0.0, 0.0, -1.0), 0.5))
      |> HittableList.add(Sphere.new(V.new(0.0, -100.5, -1.0), 100.0))

    Camera.render(world, %Camera{
      aspect_ratio: aspect_ratio,
      image_width: image_width,
    })
  end
end
