defmodule MarchiveRipperCollections.CollectionBuilder do
  defmacro register_collections do
    current_file = __ENV__.file
  dir = Path.dirname(current_file)
  enroll_glob = Path.join(dir, "enroll/*.ex")
  glue_glob = Path.join(dir, "gluedb/*.ex")
  enroll_files = Path.wildcard(enroll_glob)
  glue_files = Path.wildcard(glue_glob)
  file_list = Enum.concat(enroll_files, glue_files)
  mods = Enum.flat_map(file_list, fn(file_path) ->
    {:ok, contents} = File.read(file_path)
    pattern = ~r{defmodule \s+ ([^\s]+) }x
    Regex.scan(pattern, contents, capture: :all_but_first)
      |> List.flatten()
    end)
    m_results = Enum.map(mods, fn(m) ->
      m_atom = String.to_atom("Elixir." <> m)
      Code.ensure_compiled!(m_atom)
      m_atom.collection_information()
    end)
    quote do
      @collection_map unquote(Macro.escape(m_results))
    end
  end
end
