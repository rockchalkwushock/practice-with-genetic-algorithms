defmodule Types.Chromosome do
  @moduledoc """
  Internal expression of a Chromosome.
  """

  @type t :: %__MODULE__{
    age: integer(),
    fitness: number(),
    genes: Enum.t(),
    size: integer()
  }

  @enforce_keys :genes

  defstruct [:genes, size: 0, fitness: 0, age: 0]
end
