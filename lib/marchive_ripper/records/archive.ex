defmodule MarchiveRipper.Records.Archive do
  use Ecto.Schema
  import Ecto.Changeset

  schema "archives" do
    field :filename, :string
    field :archive_timestamp, :naive_datetime
    timestamps()
  end

  def new(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(record, params \\ %{}) do
    record
      |> cast(params, [:filename, :archive_timestamp])
      |> validate_required([:filename, :archive_timestamp])
  end
end
