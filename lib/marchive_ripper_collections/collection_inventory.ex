defmodule MarchiveRipperCollections.CollectionInventory do
  # @before_compile {MarchiveRipperCollections.CollectionBuilder, :trigger_dependencies}
  import MarchiveRipperCollections.CollectionBuilder

  register_collections()

  def collection_set() do
    @collection_map
  end

  def application_collections(application_name) do
    application_map = Enum.group_by(@collection_map, fn(i) ->
      elem(i, 0)
    end)
    Map.get(application_map, application_name, [])
  end

  def collection_for(application_collection_set, file_name) do
    collection_lookup = Enum.group_by(
      application_collection_set,
      fn(i) ->
        elem(i, 1)
      end)
    Map.get(collection_lookup, file_name, nil)
  end
end
