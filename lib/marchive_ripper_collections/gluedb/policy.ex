defmodule MarchiveRipperCollections.Gluedb.Policy do
  use MarchiveRipperCollections.NumericPrimaryCollection,
    application_name: "gluedb",
    table_name: "gluedb_policies",
    file_name: "policies.bson"
end
