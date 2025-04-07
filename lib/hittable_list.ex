defmodule HittableList do
  defstruct list: []

  def add(world, obj) do
    %{world | list: [obj | world.list]}
  end

  def hit(hittable_list, r, interval) do
    %HittableList{list: list} = hittable_list

    Enum.reduce(list, {false, interval.max, Hit.blank()}, fn object, acc ->
      # I would implement a protocol for `hit` but since
      # we only use spheres... I just don't want to yet :D
      {hits, record} = Sphere.hit(object, r, Interval.new(interval.min, elem(acc, 1)))

      if hits do
        {hits, record.t, record}
      else
        acc
      end
    end)
  end
end
