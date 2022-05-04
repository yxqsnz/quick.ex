defmodule QuickEx.Repo do
  use Ecto.Repo,
    otp_app: :quickex,
    adapter: Ecto.Adapters.SQLite3
end
