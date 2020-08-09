defmodule Gatekeeper.ContentRenderer do
  def render(_conn) do
    %Gatekeeper.Response{
      status_code: 200,
      body: "Non personalised content!",
      headers: [{"response-type", "non-personalised"}]
    }
  end

  def render(false, _conn) do
    %Gatekeeper.Response{
      status_code: 200,
      body: "Personalised content!",
      headers: [{"response-type", "personalised"}]
    }
  end

  def render(true, _conn) do
    %Gatekeeper.Response{
      status_code: 429,
      body: "Other content!",
      headers: [{"response-type", "limit-exceeded"}]
    }
  end
end
