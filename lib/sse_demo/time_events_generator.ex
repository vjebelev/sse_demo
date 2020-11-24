defmodule SseDemo.TimeEventsGenerator do
  use GenServer

  require Logger

  alias Phoenix.PubSub

  @default_interval 1_000

  def start_link(opts) do
    pubsub_name = Keyword.fetch!(opts, :pubsub_name)
    topic_name = Keyword.fetch!(opts, :topic_name)
    interval = Keyword.get(opts, :interval, @default_interval)
    GenServer.start_link(__MODULE__, {pubsub_name, topic_name, interval})
  end

  def init({pubsub_name, topic_name, interval}) do
    Process.send_after(self(), :send_time_event, interval)
    {:ok, %{pubsub_name: pubsub_name, topic_name: topic_name, interval: interval, last_run_at: nil}}
  end

  def handle_info(:send_time_event, %{pubsub_name: pubsub_name, topic_name: topic_name, interval: interval} = state) do
    message = Time.utc_now() |> Time.to_string
    PubSub.broadcast(pubsub_name, topic_name, {pubsub_name, message})
    Logger.debug(fn -> "Broadcast to topic #{topic_name}, message: #{message}" end)

    Process.send_after(self(), :send_time_event, interval)
    {:noreply, %{state | last_run_at: :calendar.local_time()}}
  end
end
