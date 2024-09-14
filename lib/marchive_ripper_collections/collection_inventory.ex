defmodule MarchiveRipperCollections.CollectionInventory do
  # @before_compile {MarchiveRipperCollections.CollectionBuilder, :trigger_dependencies}
  import MarchiveRipperCollections.CollectionBuilder

  register_collections()

  def collection_set() do
    @collection_map
  end
end
