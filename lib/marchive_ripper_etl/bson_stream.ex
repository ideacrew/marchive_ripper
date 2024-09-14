defmodule MarchiveRipperEtl.BsonStream do
  def stream_from_io(ioish) do
    Stream.resource(
      fn -> {:cont, ioish} end,
      fn(res) ->
        case res do
          {:cont, io} -> case read_entry(io) do
                           {:io_error, a} -> {[{:error, {:io_error, a}}], {:failed, io}}
                           :eof -> {:halt, io}
                           a -> {[a], {:cont, io}}
                         end
          {:failed, io} -> {:halt, io}
        end
      end,
      fn(_) -> :ok end
    )
  end

  defp read_entry(ioish) do
    case IO.binread(ioish, 4) do
      <<len::signed-little-integer-32>> -> parse_length_and_read_record(ioish, len)
      :eof -> :eof
      {:error, a} -> {:io_error, a}
      data -> {:io_error, data}
    end
  end

  defp parse_length_and_read_record(ioish, len) do
    expected_size = len - 4
    case IO.binread(ioish, expected_size) do
      :eof -> {:io_error, :eof_in_record}
      {:error, a} -> {:io_error, a}
      data ->
              case byte_size(data) do
                ^expected_size -> {:ok, BSON.decode(<<len::signed-little-integer-32>> <> data)}
                s -> {:io_error, {:data_to_short, expected_size, s}}
              end
    end
  end
end
