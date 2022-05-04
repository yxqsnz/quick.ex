# TODO: Yeah
# NOTE: Note
# WARN: Warning
# FIX: ME
# HACK: kkk
# PERF: Elixir
defmodule QuickEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      QuickEx.Repo,
      # Start the Telemetry supervisor
      QuickExWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: QuickEx.PubSub},
      # Start the Endpoint (http/https)
      QuickExWeb.Endpoint
      # Start a worker by calling: QuickEx.Worker.start_link(arg)
      # {QuickEx.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QuickEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QuickExWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
