defmodule ProblemK do
  @moduledoc """
  ProblemK.
  """

  @doc """
  Write a Task supervising process that starts a single task with
  `Task.start_link(fun)` and restarts it if it exits.
  """
  def start_link(fun) do
    GenServer.start_link(__MODULE__, fun)
  end

  def init(fun) do
    Process.flag(:trap_exit, true)
    {:ok, pid} = Task.start_link(fun)
    {:ok, {pid, fun}}
  end

  def handle_info({:EXIT, pid, _}, {pid, fun}) do
    {:ok, pid} = Task.start_link(fun)
    {:noreply, {pid, fun}}
  end

  def handle_info({:EXIT, _, _}, {_, _} = state) do
    {:noreply, state}
  end

  def terminate(_, {pid, _}) do
    Process.exit(pid, :shutdown)
    receive do
      {:EXIT, ^pid, _} ->
        :ok
    end
  end
end
