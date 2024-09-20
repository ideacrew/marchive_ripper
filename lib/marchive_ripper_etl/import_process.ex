defmodule MarchiveRipperEtl.ImportProcess do
  def generate_new_archive_record(filename, archive_timestamp) do
    cs = MarchiveRipper.Records.Archive.new(
      %{
        filename: filename,
        archive_timestamp: archive_timestamp
      }
    )
    case cs.valid? do
      false -> {:error, cs.errors}
      _ -> MarchiveRipper.Repo.insert(cs)
    end
  end

  def execute_import(archive_import_request, error_reporter) do
    {:ok, archive} = MarchiveRipperEtl.ImportProcess.generate_new_archive_record(archive_import_request.archive_filename, archive_import_request.archive_timestamp)
    table_inventory = MarchiveRipperCollections.CollectionInventory.application_collections(archive_import_request.application_name)
    case Enum.any?(table_inventory) do
      false -> :ok
      _ -> execute_import_with_collections(archive_import_request.archive_directory_path, archive, table_inventory, error_reporter)
    end
  end

  defp execute_import_with_collections(archive_directory_path, archive_record, table_inventory, error_reporter) do
    file_names_and_paths = bson_files_in_dir(archive_directory_path)
    lookups = Enum.map(file_names_and_paths, fn(fname_path) ->
      {lookup_file_name, path} = fname_path
      case MarchiveRipperCollections.CollectionInventory.collection_for(table_inventory, lookup_file_name) do
        nil ->
          {:error, {:no_mapped_collection_found, lookup_file_name, path}}
        [a|_] ->
          {:ok, {{lookup_file_name, path}, a}}
        a -> send(error_reporter, {:error, {:collection_lookup_error, a}})
      end
    end)
    {matched, errors} = Enum.split_with(lookups, fn(item) ->
      match?({:ok, _}, item)
    end)
    Enum.each(errors, fn(item) ->
      send(error_reporter, item)
    end)
    Enum.each(matched, fn(item) ->
      collection_information = elem(elem(item,1) ,1)
      module = elem(collection_information, 2)
      kind = elem(collection_information, 4)
      f_path = elem(elem(elem(item,1), 0), 1)
      execute_import_for_file(archive_record.id, f_path, module, kind, error_reporter)
    end)
  end

  defp execute_import_for_file(archive_id, path, module, kind, error_reporter) do
    io = File.open!(path, [:read, :binary])
    stream = MarchiveRipperEtl.BsonStream.stream_from_io(io)
    Enum.each(stream, fn(d) ->
      case d do
        {:ok, rec} ->
          case kind do
            :object_id ->  MarchiveRipperEtl.ImportProcess.convert_bson_with_object_id_to_record(
                              archive_id,
                              module,
                              rec
                            )
            :numeric ->  MarchiveRipperEtl.ImportProcess.convert_bson_with_numeric_id_to_record(
                           archive_id,
                           module,
                           rec
                         )
          end
        a -> send(error_reporter, {:error, a})
      end
    end)
  end

  def convert_bson_with_object_id_to_record(archive_id, collection_module, bson_map) do
    bson_id = Map.fetch!(bson_map, "_id")
    cs = collection_module.new(
      %{
        "archive_id" => archive_id,
        "bson_id" => bson_id,
        "data" => bson_map
      }
    )
    case cs.valid? do
      false -> {:error, cs.errors}
      _ -> MarchiveRipper.Repo.insert(cs)
    end
  end

  def convert_bson_with_numeric_id_to_record(archive_id, collection_module, bson_map) do
    bson_id = Map.fetch!(bson_map, "_id")
    cs = collection_module.new(
      %{
        "archive_id" => archive_id,
        "numeric_id" => bson_id,
        "data" => bson_map
      }
    )
    case cs.valid? do
      false -> {:error, cs.errors}
      _ -> MarchiveRipper.Repo.insert(cs)
    end
  end

  def bson_files_in_dir(archive_directory) do
    bson_glob = Path.join(archive_directory, "**/*.bson")
    bson_files = Path.wildcard(bson_glob)
    Enum.map(bson_files, fn(bson_file) ->
      {Path.basename(bson_file), Path.expand(bson_file)}
    end)
  end
end
