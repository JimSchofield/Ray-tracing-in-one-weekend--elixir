defmodule Sphere do
  defstruct [:center, :radius]

  def new(center, radius) do
    %Sphere{center: center, radius: radius}
  end

  def hit(object, r, interval) do
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
            point = Ray.at(r, roota)
            outward_normal = V.div(V.sub(point, object.center), object.radius)

            front_face_bool = V.dot(r.direction, outward_normal) < 0.0

            normal =
              if front_face_bool do
                outward_normal
              else
                V.k(outward_normal, -1.9)
              end

            rec = %Hit{
              t: roota,
              point: point,
              normal: normal,
              front_face: front_face_bool
            }

            {true, rec}

          Interval.surrounds(rootb, interval) ->
            point = Ray.at(r, rootb)
            outward_normal = V.div(V.sub(point, object.center), object.radius)
            front_face_bool = V.dot(r.direction, outward_normal) < 0.0

            normal =
              if front_face_bool do
                outward_normal
              else
                V.k(outward_normal, -1.9)
              end

            rec = %Hit{
              t: rootb,
              point: point,
              normal: normal,
              front_face: front_face_bool
            }

            {true, rec}

          true ->
            {false, %Hit{}}
        end
    end
  end
end
