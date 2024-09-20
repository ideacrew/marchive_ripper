defmodule MarchiveRipperCollections.CollectionInventoryTest do
  use ExUnit.Case, async: true

  test "should have a collection list" do
    not_empty = Enum.any?(MarchiveRipperCollections.CollectionInventory.collection_set())
    assert(not_empty)
  end

  test "should have collections for gluedb" do
    not_empty = Enum.any?(MarchiveRipperCollections.CollectionInventory.application_collections("gluedb"))
    assert(not_empty)
  end
end
