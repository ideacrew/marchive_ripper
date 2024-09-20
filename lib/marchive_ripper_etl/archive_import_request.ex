defmodule MarchiveRipperEtl.ArchiveImportRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "validation_schemas.archive_import_request" do
    field :archive_filename, :string
    field :archive_timestamp, :naive_datetime
    field :archive_directory_path, :string
    field :application_name, :string
  end

  def new(opts = {}) do
    changeset(%__MODULE__{}, opts)
  end

  def changeset(record, params = {}) do
    record
      |> cast(
           params,
           [
             :archive_filename,
             :archive_timestamp,
             :archive_directory_path,
             :application_name
           ]
         )
      |> validate_required(
           [
             :archive_filename,
             :archive_timestamp,
             :archive_directory_path,
             :application_name
           ]
         )
  end
end
