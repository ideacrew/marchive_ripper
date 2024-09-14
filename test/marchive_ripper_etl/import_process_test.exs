defmodule MarchiveRipperEtl.ImportProcessTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MarchiveRipper.Repo)
  end

  test "can import an example record as a gluedb person" do
    io = File.open!("test/example_data/example_collection.bson", [:read, :binary])
    stream = MarchiveRipperEtl.BsonStream.stream_from_io(io)
    {:ok, archive} = MarchiveRipperEtl.ImportProcess.generate_new_archive("example_dump.zip", NaiveDateTime.local_now())
    Enum.each(stream, fn(d) ->
      case d do
        {:ok, rec} ->
            res = MarchiveRipperEtl.ImportProcess.convert_bson_with_object_id_id_to_record(
                        archive.id,
                        MarchiveRipperCollections.Gluedb.Person,
                        rec
                      )
            IO.puts(res)
        a -> IO.puts(a)
      end
    end)
  end
end
