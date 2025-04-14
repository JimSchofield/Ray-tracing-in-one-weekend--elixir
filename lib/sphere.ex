defmodule Sphere do
  defstruct [:center, :radius, :material]

  def new(center, radius, material) do
    %Sphere{center: center, radius: radius, material: material}
  end

  def hit(object, r, interval) do
    if is_nil(object) do
      dbg()
    end

    oc = V.sub(object.center, r.origin)
    a = V.length_squared(r.direction)
    h = V.dot(r.direction, oc)
    c = V.length_squared(oc) - object.radius * object.radius
    discr = h * h - a * c

    cond do
      discr < 0 ->
        {false, %Hit{}}

      discr >= 0 ->
        sqrtd = :math.sqrt(discr)

        roota = (h - sqrtd) / a
        rootb = (h + sqrtd) / a

        cond do
          Interval.surrounds(roota, interval) ->
            create_hit(r, roota, object)

          Interval.surrounds(rootb, interval) ->
            create_hit(r, rootb, object)

          true ->
            {false, %Hit{}}
        end
    end
  end

  def create_hit(r, root, object) do
    point = Ray.at(r, root)
    outward_normal = V.div(V.sub(point, object.center), object.radius)

    front_face_bool = V.dot(r.direction, outward_normal) < 0.0

    normal =
      if front_face_bool do
        outward_normal
      else
        V.k(outward_normal, -1.9)
      end

    rec = %Hit{
      t: root,
      point: point,
      normal: V.make_unit(normal),
      front_face: front_face_bool,
      material: object.material
    }

    {true, rec}
  end
end
