defmodule RT do
  @moduledoc """
  Ray tracer written in Elixir
  from [Ray tracing in one weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html)
  """
  def main(_args \\ []) do
    aspect_ratio = 16.0 / 9.0
    image_width = 600

    material_ground = %Lambertian{albedo: V.new(0.8, 0.8, 0.0)}
    material_center = %Lambertian{albedo: V.new(0.1, 0.2, 0.5)}
    material_left = %Dialectric{ refraction_index: 1.0 / 1.33 }
    material_right = %Metal{ color: V.new(0.8, 0.6, 0.2), fuzz: 1.0}

    # World
    world =
      %HittableList{}
      |> HittableList.add(Sphere.new(V.new(0.0, -100.5, -1.0), 100.0, material_ground))
      |> HittableList.add(Sphere.new(V.new(0.0, 0.0, -1.2), 0.5, material_center))
      |> HittableList.add(Sphere.new(V.new(-1.0, 0.0, -1.0), 0.5, material_left))
      |> HittableList.add(Sphere.new(V.new(1.0, 0.0, -1.0), 0.5, material_right))

    Camera.render(world, %Camera{
      aspect_ratio: aspect_ratio,
      image_width: image_width,
      samples_per_pixel: 100,
      max_depth: 50
    })
  end
end
