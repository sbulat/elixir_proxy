defmodule KeenProxy.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post "/" do
    cached_authorize = KeenProxy.Cache.get "subdomain:state-sites"

    unless cached_authorize do
      case chargify_authorized() do
        {:ok, %HTTPoison.Response{status_code: 403}} ->
          set_response(conn, 403, "Forbidden")
          |> halt()
        {:ok, %HTTPoison.Response{status_code: 200}} ->
          KeenProxy.Cache.set "subdomain:state-sites", true
      end
    end

    resp = HTTPoison.post(
      "http://localhost:4567/api/events",
      "{\"key1\":\"value1\",\"key2\":\"value2\"}",
      [{"Content-Type", "application/json"}, {"Authorization", "123:345"}]
    )

    case resp do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        set_response(conn, 200, "OK")
      {:error, %HTTPoison.Error{reason: reason}} ->
        set_response(conn, 401, reason)
      _ ->
        set_response(conn, 401, "Unexpected")
    end
  end

  defp chargify_authorized do
    basic_string = Base.encode64("uoRoDThncTkOn0d3HAOoHIRvVpXYKqC2l25Bn4zhs")

    HTTPoison.get(
      "http://events.chargify.test/state-sites/verify_token/" <> basic_string
    )
  end

  def set_response(conn, code, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Poison.encode!(%{message: message}))
  end
end
