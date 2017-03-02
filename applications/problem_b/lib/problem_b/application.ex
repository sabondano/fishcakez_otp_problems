defmodule ProblemB.Application do
  @moduledoc false

  alias ProblemB.{Server, TaskSupervisor}

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [supervisor(TaskSupervisor, []), worker(Server, [])]
    Supervisor.start_link(children, [strategy: :one_for_all])
  end
end
