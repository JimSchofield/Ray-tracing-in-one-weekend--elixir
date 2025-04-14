defmodule RT do
  @moduledoc """
  Ray tracer written in Elixir
  from [Ray tracing in one weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html)
  """
  def main(_args \\ []) do
    ground_material = %Lambertian{albedo: V.splat(0.5)}
    ground = %Sphere{center: V.new(0.0, -1000.0, 0.0), radius: 1000.0, material: ground_material}

    list =
      for a <- -11..11, b <- -11..11 do
        choose_mat = Random.float()
        center = V.new(a + 0.9 * Random.float(), 0.2, b + 0.9 * Random.float())

        if V.sub(center, V.new(4, 0.2, 0)) |> V.length() > 0.9 do
          case choose_mat do
            x when x < 0.9 ->
              albedo = V.mult(Random.vec3(), Random.vec3())
              sphere_material = %Lambertian{albedo: albedo}

              %Sphere{center: center, radius: 0.2, material: sphere_material}

            x when x < 0.95 ->
              color = Random.vec3(0.5, 1)
              fuzz = Random.float(0, 0.5)
              sphere_material = %Metal{color: color, fuzz: fuzz}

              %Sphere{center: center, radius: 0.2, material: sphere_material}

            _ ->
              # Dialectric
              sphere_material = %Dialectric{refraction_index: 1.5}

              %Sphere{center: center, radius: 0.2, material: sphere_material}
          end
        end
      end

    big_spheres = [
      %Sphere{
        center: V.new(0, 1, 0),
        radius: 1.0,
        material: %Dialectric{refraction_index: 1.5}
      },
      %Sphere{
        center: V.new(-4, 1, 0),
        radius: 1.0,
        material: %Lambertian{albedo: V.new(0.4, 0.2, 0.1)}
      },
      %Sphere{
        center: V.new(4, 1, 0),
        radius: 1.0,
        material: %Metal{color: V.new(0.7, 0.6, 0.5), fuzz: 0.0}
      }
    ]

    # World
    world =
      %HittableList{}
      |> HittableList.add(ground)
      |> HittableList.add_list(big_spheres)
      |> HittableList.add_list(Enum.reject(list, &is_nil/1))

    Camera.render(world, %Camera{
      aspect_ratio: 16.0 / 9.0,
      image_width: 200,
      samples_per_pixel: 10,
      max_depth: 5,
      vfov: 20,
      lookfrom: V.new(13, 2.0, 3.0),
      lookat: V.new(0.0, 0.0, 0.0),
      vup: V.new(0, 1, 0),
      defocus_angle: 0.6,
      focus_dist: 10
    })
  end
end
