defmodule MarchiveRipper.Repo do
  use Ecto.Repo,
    otp_app: :marchive_ripper,
    adapter: Ecto.Adapters.Postgres
end
