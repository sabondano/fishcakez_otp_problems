defmodule ProblemD do
  @moduledoc """
  ProblemD.
  """

  @enforce_keys [:pid, :ref]
  defstruct [:pid, :ref]

  @doc """
  Start a task and await on the result, as `Task.async`.
  """
  def async(fun) do
    {pid, ref} = Process.spawn(__MODULE__, :init, [fun, self()], [:link, :monitor])
    # {:ok, pid} = Task.start_link(__MODULE__, :init, [fun, self()])
    # ref = Process.monitor(pid)
    send(pid, {:go, self(), ref})
    %ProblemD{pid: pid, ref: ref}
  end

  @doc false
  def init(fun, parent) do
    receive do
      {:go, ^parent, ref} ->
        send(parent, {ref, fun.()})
        exit(:normal) # not needed but makes it more explicit.
    end
  end

  @doc """
  Await the result of a task, as `Task.await`
  """
  def await(%ProblemD{ref: ref} = task, timeout) do
    receive do
      {^ref, result} ->
        Process.demonitor(ref, [:flush])
        result
      {:DOWN, ^ref, :process, _, reason} ->
        exit({reason, {__MODULE__, :await, [task, timeout]}})
    after
      timeout ->
        Process.demonitor(ref, [:flush])
        exit({:timeout, {__MODULE__, :await, [task, timeout]}})
    end
  end

  @doc """
  Yield to wait the result of a task, as `Task.yield`.
  """
  def yield(%ProblemD{ref: ref} = _task, timeout) do
    receive do
      {^ref, result} ->
        Process.demonitor(ref, [:flush])
        {:ok,  result}
      {:DOWN, ^ref, :process, _, reason} ->
        {:exit, reason}
    after
      timeout ->
        nil
    end
  end
end
