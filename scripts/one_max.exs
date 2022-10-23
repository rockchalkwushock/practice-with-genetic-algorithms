defmodule OneMax do
  @behaviour Problem
  alias Types.Chromosome
  import Enum, only: [random: 1, sum: 1]

  @impl true
  def genotype do
    genes = for _ <- 1..42, do: random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl true
  def fitness_function(chromosome), do: sum(chromosome.genes)

  @impl true
  def terminate?([best | _]), do: best.fitness == 42
end

solution = Genetics.run(OneMax)

IO.write("\n")
IO.inspect(solution)
