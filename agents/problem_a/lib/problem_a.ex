defmodule ProblemA do
  @moduledoc """
  ProblemA.
  """

  @doc """
  Start Agent with map as state.
  """
  def start_link(map) when is_map(map) do
    # Agent.start_link(fn() -> map end, [name: __MODULE__]) <-- to add name
    Agent.start_link(fn() -> map end)
  end

  @doc """
  Fetch a value from the agent.
  """
  def fetch!(agent, key) do
    # Agent.get(agent, Map, :fetch!, [key])
    fetch = fn(state) ->
      try do
        Map.fetch!(state, key)
      rescue
        err in [KeyError] ->
          {:error, err}
      else
        val ->
          {:ok, val}
      end
    end

    case Agent.get(agent, fetch) do
      {:ok, value} ->
        value
      {:error, err} ->
        raise err
    end
  end
end
