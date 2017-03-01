defmodule ProblemB do
  @moduledoc """
  ProblemB.
  """

  @doc """
  Stop a GenServer. Expects GenServer to stop with reason `reason` on receiving
  call `{:stop, reason}`. GenServer should reply with message `:ok`.
  """
  def stop(gen_server) do
    ref = Process.monitor(gen_server)
    GenServer.call(gen_server, {:stop, :normal}, :infinity)
    receive do
      # {:DOWN, ^ref, :process, ^gen_server, :normal} ->
      {:DOWN, ^ref, _, _, :normal} -> # <-- you don't HAVE TO match on :process and gen_server
        :ok
      {:DOWN, ^ref, _, _, reason} ->
        exit({reason, {__MODULE__, :stop, [gen_server]}})
    end


    # ref = Process.monitor(gen_server)
    # case GenServer.call(gen_server, {:stop, :normal}, :infinity) do
    #   :ok ->
    #     send(gen_server, :stop)
    #     receive do
    #       {:DOWN, ^ref, :process, ^gen_server, :normal} ->
    #         :ok
    #     end
    # end
  end
end
