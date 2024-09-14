defmodule MarchiveRipperCollections.CollectionInventoryTest do
  use ExUnit.Case, async: true

  test "should have a collection list" do
    IO.puts(MarchiveRipperCollections.CollectionInventory.collection_set())
  end
end
