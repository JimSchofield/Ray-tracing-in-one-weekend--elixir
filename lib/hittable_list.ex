defmodule HittableList do
  defstruct list: []

  def add(world, obj) do
    %{world | list: [obj | world.list]}
  end

  def hit(hittable_list, r, ray_tmin, ray_tmax) do
    %HittableList{list: list} = hittable_list

    Enum.reduce(list, {false, ray_tmax, Hit.blank()}, fn object, acc ->
      # I would implement a protocol for `hit` but since
      # we only use spheres... I just don't want to yet :D
      {hits, record} = Sphere.hit(object, r, ray_tmin, ray_tmax)

      if hits do
        {hits, record.t, record}
      else
        acc
      end
    end)
  end
end
