defmodule MarchiveRipperEtl.BsonStreamTest do
  use ExUnit.Case, async: true

  test "can read a simple bson file" do
    io = File.open!("test/example_data/example_collection.bson", [:read, :binary])
    stream = MarchiveRipperEtl.BsonStream.stream_from_io(io)
  end
end
