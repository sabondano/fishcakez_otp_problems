defmodule ProblemC do
  @moduledoc """
  ProblemC.
  """

  @doc """
  Run an anonymous function in a separate process.

  Returns `{:ok, result} if the function runs successfully, otherwise
  `{:error, exception}` if an exception is raised.
  """
  def run(fun) do
    wrapper = fn() ->
      try do
        fun.()
      rescue
        err ->
          {:error, err}
      else
          result ->
            {:ok, result}
      end
    end

    task = Task.async(wrapper)
    Task.await(task, :infinity)
  end
end
