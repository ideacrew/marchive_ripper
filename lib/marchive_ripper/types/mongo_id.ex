defmodule MarchiveRipper.Types.MongoId do
  use Ecto.Type

  def type, do: :bitstring

  def cast(%BSON.ObjectId{value: binary}), do: {:ok, Base.encode16(binary)}
  def cast(a), do: Ecto.Type.cast(:string, a)

  def dump(%BSON.ObjectId{value: binary}), do: {:ok, Base.encode16(binary)}
  def dump(a), do: Ecto.Type.cast(:string, a)

  def load(data), do: {:ok, data}
end
