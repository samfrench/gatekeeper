defmodule Gatekeeper.PersonalisedManager do
  def handle(conn) do
    %Gatekeeper.Response{
      status_code: 200,
      body: "Dynamic content!",
      headers: [{"personalised", "response"}]
    }
  end
end
