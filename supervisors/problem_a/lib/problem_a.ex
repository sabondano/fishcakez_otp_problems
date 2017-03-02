defmodule ProblemA do
  @moduledoc """
  ProblemA.
  """

  @doc """
  Start a task that is run again if it crashes
  """
  def start_link(fun) do
    # shutdown option for how long to wait
    # or use brutal kill
    # the default is shutdown: :infinity
    import Supervisor.Spec, only: [worker: 3]
    Supervisor.start_link([worker(Task, [fun], [restart: :transient])],
                          [strategy: :one_for_one, max_restarts: 1])
    # Task.start_link(fun)
  end
end
