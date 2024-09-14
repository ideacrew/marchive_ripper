defmodule MarchiveRipperCollections.Gluedb.Person do
  use MarchiveRipperCollections.BsonPrimaryCollection,
    application_name: "gluedb",
    table_name: "gluedb_people",
    file_name: "people.bson"
end
