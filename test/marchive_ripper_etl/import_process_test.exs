defmodule MarchiveRipperEtl.ImportProcessTest do
  use ExUnit.Case, async: true

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MarchiveRipper.Repo)
  end

  test "can import an example record as a gluedb person" do
    io = File.open!("test/example_data/example_collection.bson", [:read, :binary])
    stream = MarchiveRipperEtl.BsonStream.stream_from_io(io)
    {:ok, archive} = MarchiveRipperEtl.ImportProcess.generate_new_archive_record("example_dump.zip", NaiveDateTime.local_now())
    Enum.each(stream, fn(d) ->
      case d do
        {:ok, rec} ->
            res = MarchiveRipperEtl.ImportProcess.convert_bson_with_object_id_to_record(
                        archive.id,
                        MarchiveRipperCollections.Gluedb.Person,
                        rec
                      )
        a -> assert(false, IO.inspect(a))
      end
    end)
  end

  test "can import a file set with no matching collections" do
    error_reporter = spawn(fn() ->
      error_listener()
    end)
    import_request = %MarchiveRipperEtl.ArchiveImportRequest{
      application_name: "gluedb",
      archive_filename: "gluedb_example.zip",
      archive_timestamp: NaiveDateTime.local_now(),
      archive_directory_path: "test/example_data/dump/gluedb_example"
    }
    MarchiveRipperEtl.ImportProcess.execute_import(import_request, error_reporter)
    send(error_reporter, :done)
  end

  defp error_listener() do
    receive do
      :done -> :ok
      a ->
        IO.inspect(a)
        error_listener()
    end
  end
end
