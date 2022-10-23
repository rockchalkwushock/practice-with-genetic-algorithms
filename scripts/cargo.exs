defmodule Cargo do
  @behaviour Problem
  alias Types.Chromosome
  import Enum, only: [map: 2, max_by: 2, random: 1, sum: 1, zip: 2]

  @impl true
  def genotype() do
    genes = for _ <- 1..10, do: random(0..1)
    %Chromosome{genes: genes, size: 10}
  end

  @impl true
  def fitness_function(chromosome) do
    profits = [6,5,8,9,6,7,3,1,2,6]

    profits
    |> zip(chromosome.genes)
    |> map(fn {p, g} -> p * g end)
    |> sum()
  end

  @impl true
  def terminate?(population) do
    max_by(population, &Cargo.fitness_function/1).fitness == 53
  end
end

solution = Genetics.run(Cargo, population_size: 50)

IO.write("\n")
IO.inspect(solution)

weight =
  solution.genes
  |> Enum.zip([10,6,8,7,10,9,7,11,6,8])
  |> Enum.map(fn {g, w} -> w * g end)
  |> Enum.sum()

IO.write("\nWeight is: #{weight}\n")
