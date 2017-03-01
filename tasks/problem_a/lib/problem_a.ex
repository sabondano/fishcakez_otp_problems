defmodule ProblemA do
  @moduledoc """
  ProblemA.
  """

  @doc """
  Start and links to process that stops when it receives the message `:stop`.
  """
  def start_link() do
    Task.start_link(fn() ->
      receive do
        :stop ->
          # For it to exit it expects an exit message with ':normal' reason.
          exit(:normal)
      end
    end)
  end
end
