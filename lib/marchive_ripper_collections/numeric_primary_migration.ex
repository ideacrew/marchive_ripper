defmodule MarchiveRipperCollections.NumericPrimaryMigration do
  defmacro __using__(opts) do
    table_name = Keyword.fetch!(opts, :table_name)
    index_create_string = "CREATE INDEX #{table_name}_data ON #{table_name} USING GIN(data)"
    quote do
      use Ecto.Migration

      def up do
        create table(unquote(table_name)) do
          add :numeric_id, :integer, null: false
          add :archive_id, references("archives"), null: false
          add :data, :map, default: %{}
          timestamps()
        end

        create index(unquote(table_name), [:archive_id])
        create index(unquote(table_name), [:numeric_id])
        execute(unquote(index_create_string))
      end

      def down do
        drop table(unquote(table_name))
      end
    end
  end
end
