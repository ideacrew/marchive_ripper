defmodule MarchiveRipperEtl.ImportProcess do
  def generate_new_archive(filename, archive_timestamp) do
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

  def convert_bson_with_object_id_id_to_record(archive_id, collection_module, bson_map) do
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

  def convert_bson_with_numeric_id_id_to_record(archive_id, collection_module, bson_map) do
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
end
