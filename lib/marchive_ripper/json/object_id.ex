defimpl Jason.Encoder, for: BSON.ObjectId do
  def encode(value, opts) do
    Jason.Encode.string(Base.encode16(value.value), opts)
  end
end
