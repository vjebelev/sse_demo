defmodule SseDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SseDemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SseDemo.PubSub},
      # Start the Endpoint (http/https)
      SseDemoWeb.Endpoint,
      # Start Time Events Generator
      {SseDemo.TimeEventsGenerator, [pubsub_name: SseDemo.PubSub, topic_name: "time", interval: 1]},
      # Start a worker by calling: SseDemo.Worker.start_link(arg)
      # {SseDemo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SseDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SseDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
