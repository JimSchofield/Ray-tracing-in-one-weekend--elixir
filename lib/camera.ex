defmodule Camera do
  defstruct [
    :image_width,
    :aspect_ratio,
    :samples_per_pixel,
    :max_depth,
    :vfov,
    :lookfrom,
    :lookat,
    :vup,
    :defocus_angle,
    :focus_dist
  ]

  def ray_color(r, max_depth, hittable_list) do
    if max_depth <= 0 do
      V.splat(0.0)
    else
      {hit, _max, record} = HittableList.hit(hittable_list, r, Interval.new(0.001, :infinity))

      if hit do
        {is_hit, attenuation, scattered} = Scatter.scatter(record.material, r, record)

        if is_hit do
          V.mult(attenuation, ray_color(scattered, max_depth - 1, hittable_list))
        else
          V.splat(0.0)
        end
      else
        unit_direction = V.make_unit(r.direction)
        a = 0.5 * (unit_direction.y + 1.0)

        V.k(V.new(1.0, 1.0, 1.0), 1.0 - a)
        |> V.add(V.k(V.new(0.5, 0.7, 1.0), a))
      end
    end
  end

  # This is rediculous, but I'm not sure how Elixirites would
  # address this
  def get_ray(
        i,
        j,
        pixel00_loc,
        pixel_delta_u,
        pixel_delta_v,
        center,
        defocus_angle,
        defocus_disk_u,
        defocus_disk_v
      ) do
    offset = V.new(Random.float() - 0.5, Random.float() - 0.5, 0)

    pixel_sample =
      pixel00_loc
      |> V.add(V.k(i + offset.x, pixel_delta_u))
      |> V.add(V.k(j + offset.y, pixel_delta_v))

    ray_origin =
      if defocus_angle <= 0 do
        center
      else
        defocus_disk_sample(center, defocus_disk_u, defocus_disk_v)
      end

    ray_direction = V.sub(pixel_sample, ray_origin)

    Ray.new(ray_origin, ray_direction)
  end

  def render(world, config) do
    %Camera{
      image_width: image_width,
      aspect_ratio: aspect_ratio,
      samples_per_pixel: samples_per_pixel,
      max_depth: max_depth,
      vfov: vfov,
      lookfrom: lookfrom,
      lookat: lookat,
      vup: vup,
      defocus_angle: defocus_angle,
      focus_dist: focus_dist
    } = config

    pixel_samples_scale = 1.0 / samples_per_pixel

    camera_center = lookfrom

    image_height = trunc(image_width / aspect_ratio)

    theta = degrees_to_radians(vfov)
    h = :math.tan(theta / 2.0)
    viewport_height = 2.0 * h * focus_dist
    viewport_width = viewport_height * (image_width / image_height)

    # u,v,w unit basis vectors for camera coordinate frame
    w = V.make_unit(V.sub(lookfrom, lookat))
    u = V.make_unit(V.cross(vup, w))
    v = V.cross(w, u)

    viewport_u = V.k(viewport_width, u)
    viewport_v = V.k(-1.0 * viewport_height, v)

    pixel_delta_u = V.div(viewport_u, image_width)
    pixel_delta_v = V.div(viewport_v, image_height)

    viewport_upper_left =
      camera_center
      |> V.sub(V.k(focus_dist, w))
      |> V.sub(V.div(viewport_u, 2))
      |> V.sub(V.div(viewport_v, 2))

    defocus_radius = focus_dist * :math.tan(degrees_to_radians(defocus_angle / 2))
    defocus_disk_u = V.k(u, defocus_radius)
    defocus_disk_v = V.k(v, defocus_radius)

    pixel00_loc = V.add(viewport_upper_left, V.div(V.add(pixel_delta_u, pixel_delta_v), 2))

    result =
      Flow.from_enumerable(0..(image_height - 1))
      |> Flow.map(fn j ->
        IO.puts("Rendering row #{j}")

        result =
          Flow.from_enumerable(0..(image_width - 1))
          |> Flow.map(fn i ->
            pixel_color =
              Enum.reduce(0..(samples_per_pixel - 1), V.splat(0.0), fn _i, acc ->
                r =
                  get_ray(
                    i,
                    j,
                    pixel00_loc,
                    pixel_delta_u,
                    pixel_delta_v,
                    camera_center,
                    defocus_angle,
                    defocus_disk_u,
                    defocus_disk_v
                  )

                V.add(acc, ray_color(r, max_depth, world))
              end)

            pixel = Color.write_color(V.k(pixel_color, pixel_samples_scale))

            pixel
          end)
          |> Enum.to_list()
          |> Enum.join()

        result
      end)
      |> Enum.to_list()
      |> Enum.join()

    header = """
    P3
    #{image_width} #{image_height}
    255
    """

    file = header <> result

    File.write("./test.ppm", file)
    IO.puts("Done")
  end

  def degrees_to_radians(deg) do
    deg / 180 * :math.pi()
  end

  def defocus_disk_sample(center, defocus_disk_u, defocus_disk_v) do
    p = Random.random_in_unit_disk()

    center
    |> V.add(V.k(p.x, defocus_disk_u))
    |> V.add(V.k(p.y, defocus_disk_v))
  end
end
