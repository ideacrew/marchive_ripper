defmodule MarchiveRipper.Repo.Migrations.AddArchives do
  use Ecto.Migration

  def change do
    create table("archives") do
      add :filename, :string, size: 255
      add :archive_timestamp, :timestamp
      timestamps()
    end
  end
end
