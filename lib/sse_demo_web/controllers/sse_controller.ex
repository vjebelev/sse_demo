defmodule SseDemoWeb.SseController do
  use SseDemoWeb, :controller
  require Logger

  def subscribe(conn, params) do
    case get_topics(params) do
      topics when is_list(topics) ->
        Logger.debug(fn -> "Subscribed to topics #{inspect(topics)}" end)
        SsePhoenixPubsub.stream(conn, {SseDemo.PubSub, topics})
       _ ->
        Logger.error("No topics provided")
    end
  end

  defp get_topics(params) do
    case params["topics"] do
      str when is_binary(str) -> String.split(str, ",")
      nil -> []
    end
  end
end
