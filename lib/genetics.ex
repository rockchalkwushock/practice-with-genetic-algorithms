defmodule Genetics do
  @moduledoc """
  Documentation for `Genetics`.
  """
  import Enum, only: [chunk_every: 2, map: 2, reduce: 3, shuffle: 1, sort_by: 3, split: 2]
  import Keyword, only: [get: 3]
  import List, only: [to_tuple: 1]

  @doc """
  run/4
  Entry point for genetic algorithm framework.
  """
  def run(fitness_function, genotype, max_fitness, opts \\ []) do
    population = initialize(genotype)

    population
    |> evolve(fitness_function, genotype, max_fitness, opts)
  end


  defp evolve(population, fitness_function, genotype, max_fitness, opts) do
    population = evaluate(population, fitness_function, opts)

    best = hd(population)

    IO.write("\rCurrent Best: #{fitness_function.(best)}")

    if fitness_function.(best) == max_fitness do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutation(opts)
      |> evolve(fitness_function, genotype, max_fitness, opts)
    end
  end

  defp initialize(genotype, opts \\ []) do
    population_size = get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  defp evaluate(population, fitness_function, _opts) do
    population |> sort_by(fitness_function, &>=/2)
  end

  defp select(population, _opts) do
    population
    |> chunk_every(2)
    |> map(&to_tuple(&1))
  end

  defp crossover(population, _opts) do
    population
    |> reduce(
      [],
      fn {p1, p2}, acc ->
        cx_point = :rand.uniform(length(p1))
        {{h1, t1}, {h2, t2}} = {split(p1, cx_point), split(p2, cx_point)}
        {c1, c2} = {h1 ++ t2, h2 ++ t1}
        [c1, c2 | acc]
      end
    )
  end

  defp mutation(population, _opts) do
    population
    |> map(
      fn chromosome ->
        if :rand.uniform() < 0.05 do
          shuffle(chromosome)
        else
          chromosome
        end
      end
    )
  end
end
