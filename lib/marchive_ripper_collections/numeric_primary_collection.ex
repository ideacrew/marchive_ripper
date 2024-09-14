defmodule MarchiveRipperCollections.NumericPrimaryCollection do
  defmacro __using__(opts) do
    f_name = Keyword.fetch!(opts, :file_name)
    table_name = Keyword.fetch!(opts, :table_name)
    app_name = Keyword.fetch!(opts, :application_name)
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      schema unquote(table_name) do
        field :numeric_id, :integer
        field :data, :map, default: %{}
        belongs_to :archive, MarchiveRipper.Records.Archive
        timestamps()
      end

      def new(params \\ %{}) do
        changeset(%__MODULE__{}, params)
      end

      def changeset(record, params \\ %{}) do
        record
          |> cast(params, [:data, :archive_id, :numeric_id])
          |> validate_required([:data, :archive_id, :numeric_id])
      end

      def collection_information do
        {unquote(app_name), unquote(f_name), __MODULE__, unquote(table_name), :numeric}
      end
    end
  end
end
