defmodule MarchiveRipperCollections.Gluedb.PersonTest do
  use ExUnit.Case, async: true

  test "has a registered collection for the file" do
    application_collections = MarchiveRipperCollections.CollectionInventory.application_collections("gluedb")
    person_collection = MarchiveRipperCollections.CollectionInventory.collection_for(application_collections, "people.bson")
    assert(person_collection != nil)
  end
end
