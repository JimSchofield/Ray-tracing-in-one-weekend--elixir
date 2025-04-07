defmodule Camera do
  defstruct [
    :image_width,
    :aspect_ratio,
  ]

  def ray_color(r, hittable_list) do
    {hit, _max, record} = HittableList.hit(hittable_list, r, Interval.new(0.0, :infinity))

    if hit do
      record.normal
      |> V.add(V.new(1.0, 1.0, 1.0))
      |> V.k(0.5)
    else
      unit_direction = V.make_unit(r.direction)
      a = 0.5 * (V.y(unit_direction) + 1.0)

      V.k(Color.new(1.0, 1.0, 1.0), 1.0 - a)
      |> V.add(V.k(Color.new(0.5, 0.7, 1.0), a))
    end
  end

  def render(world, config) do
    %Camera{
      image_width: image_width,
      aspect_ratio: aspect_ratio
    } = config

    image_height = trunc(image_width / aspect_ratio)

    focal_length = 1.0
    viewport_height = 2.0
    viewport_width = viewport_height * (image_width / image_height)

    camera_center = V.new(0, 0, 0)

    viewport_u = V.new(viewport_width, 0, 0)
    viewport_v = V.new(0, -viewport_height, 0)

    pixel_delta_u = V.div(viewport_u, image_width)
    pixel_delta_v = V.div(viewport_v, image_height)

    viewport_upper_left =
      camera_center
      |> V.sub([0, 0, focal_length])
      |> V.sub(V.div(viewport_u, 2))
      |> V.sub(V.div(viewport_v, 2))

    pixel00_loc = V.add(viewport_upper_left, V.div(V.add(pixel_delta_u, pixel_delta_v), 2))

    result =
      Enum.reduce(0..(image_height - 1), "", fn j, jacc ->
        IO.puts("Rendering row #{j}")

        jacc <>
          Enum.reduce(0..(image_width - 1), "", fn i, iacc ->
            pixel_center =
              pixel00_loc
              |> V.add(V.k(pixel_delta_u, i))
              |> V.add(V.k(pixel_delta_v, j))

            ray_direction = V.sub(pixel_center, camera_center)

            r = Ray.new(camera_center, ray_direction)

            pixel_color = ray_color(r, world)
            pixel = Color.write_color(pixel_color)

            # pixel <> iacc
            iacc <> pixel
          end)
      end)

    header = """
    P3
    #{image_width} #{image_height}
    255
    """

    file = header <> result

    File.write("./test.ppm", file)
    IO.puts("Done")
  end
end
