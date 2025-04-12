defprotocol Scatter do
  def scatter(material, ray_in, hit_record)
end

defmodule Lambertian do
  defstruct [:albedo]

  defimpl Scatter, for: Lambertian do
    def scatter(material, _ray_in, rec) do
      scatter_direction = rec.normal |> V.add(Random.unit_vector())

      if V.near_zero(scatter_direction) do
        scattered = Ray.new(rec.point, rec.normal)

        {true, material.albedo, scattered}
      else
        scattered = Ray.new(rec.point, scatter_direction)

        {true, material.albedo, scattered}
      end
    end
  end
end

defmodule Metal do
  defstruct [:color, :fuzz]

  defimpl Scatter, for: Metal do
    def scatter(material, ray_in, rec) do
      ref = V.reflect(ray_in.direction, rec.normal)

      reflected = V.add(V.make_unit(ref), V.k(material.fuzz,Random.unit_vector()))

      scattered = Ray.new(rec.point, reflected)

      hit = V.dot(scattered.direction, rec.normal) > 0

      {hit, material.color, scattered}
    end
  end
end
