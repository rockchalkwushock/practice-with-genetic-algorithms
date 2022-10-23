defmodule Speller do
  @behaviour Problem
  alias Types.Chromosome
  import Enum, only: [random: 1, take: 2]
  import Stream, only: [repeatedly: 1]
  import String, only: [jaro_distance: 2]

  @impl true
  def genotype do
    genes =
      repeatedly(fn -> random(?a..?z) end)
      |> take(34)
    %Chromosome{genes: genes, size: 34}
  end

  @impl true
  def fitness_function(chromosome) do
    target = "supercalifragilisticexpialidocious"
    guess = List.to_string(chromosome.genes)
    jaro_distance(target, guess)
  end

  @impl true
  def terminate?([best | _]), do: best.fitness == 1
end

solution = Genetics.run(Speller)

IO.write("\n")
IO.inspect(solution)
