defmodule ProblemH do
  @moduledoc """
  ProblemH.
  """

  alias __MODULE__.{Server, Client}

  @doc """
  Start the GenServers.
  """
  def start_link() do
    strategy = :one_for_all

    ## Do not change code below

    import Supervisor.Spec, only: [worker: 2]

    children = [worker(Server, []), worker(Client, [])]

    Supervisor.start_link(children, [strategy: strategy, max_restarts: 1])
  end

  defmodule Server do
    @moduledoc false

    use GenServer
    alias ProblemH.Client

    def start_link() do
      GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
    end

    def call_me_back(), do: GenServer.cast(__MODULE__, {:call_me_back, self()})

    def init(_) do
      {:ok, nil}
    end

    def handle_cast({:call_me_back, pid}, _) do
      {:noreply, Client.increment(pid)}
    end
  end

  defmodule Client do
    @moduledoc false

    use GenServer
    alias ProblemH.Server

    def start_link() do
      GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
    end

    def increment(pid), do: GenServer.call(pid, :increment)

    def init(_) do
      Server.call_me_back()
      {:ok, 0}
    end

    def handle_call(:increment, _, counter) do
      Server.call_me_back()
      counter = counter + 1
      {:reply, counter, counter}
    end
  end
end
