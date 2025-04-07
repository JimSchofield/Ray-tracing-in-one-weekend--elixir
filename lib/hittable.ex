defmodule Hit do
  defstruct [:point, :normal, :t, :front_face]

  def newRecord(point, normal, t) do
    %Hit{point: point, normal: normal, t: t}
  end

  def blank do
    %Hit{}
  end
end
