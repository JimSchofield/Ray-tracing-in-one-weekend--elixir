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

      reflected = V.add(V.make_unit(ref), V.k(material.fuzz, Random.unit_vector()))

      scattered = Ray.new(rec.point, reflected)

      hit = V.dot(scattered.direction, rec.normal) > 0

      {hit, material.color, scattered}
    end
  end
end

defmodule Dialectric do
  defstruct [:refraction_index]

  defimpl Scatter, for: Dialectric do
    def scatter(material, ray_in, rec) do
      attenuation = V.splat(1.0)

      ri =
        if rec.front_face do
          1.0 / material.refraction_index
        else
          material.refraction_index
        end

      unit_direction = V.make_unit(ray_in.direction)

      cos_theta = min(V.dot(V.neg(unit_direction), rec.normal), 1.0)
      sin_theta = :math.sqrt(1.0 - cos_theta * cos_theta)

      cannot_refract = ri * sin_theta > 1.0

      direction =
        if cannot_refract || reflectance(cos_theta, ri) > Random.float() do
          V.reflect(unit_direction, rec.normal)
        else
          V.refract(unit_direction, rec.normal, ri)
        end

      scattered = Ray.new(rec.point, direction)

      {true, attenuation, scattered}
    end

    def reflectance(cosine, refraction_index) do
      r = (1.0 - refraction_index) / (1.0 + refraction_index)
      r0 = r * r

      r0 + (1.0 - r0) * :math.pow(1.0 - cosine, 5)
    end
  end
end
