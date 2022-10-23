defmodule Genetics do
  @moduledoc """
  Documentation for `Genetics`.
  """
  import Enum, only: [chunk_every: 2, map: 2, max_by: 2, reduce: 3, shuffle: 1, sort_by: 3, split: 2]
  import Keyword, only: [get: 3]
  import List, only: [to_tuple: 1]
  alias Types.Chromosome

  @doc """
  run/4
  Entry point for genetic algorithm framework.
  """
  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0)

    population
    |> evolve(problem, 0, 0, 0, opts)
  end

  defp evolve(population, problem, generation, last_max_fitness, temperature, opts) do
    population = evaluate(population, &problem.fitness_function/1, opts)

    best = max_by(population, &problem.fitness_function/1)
    best_fitness = best.fitness
    temperature = 0.8 * (temperature + (best_fitness - last_max_fitness))

    IO.write("\rCurrent Best: #{best.fitness}")

    if problem.terminate?(population, generation, temperature) do
      best
    else
      generation = generation + 1

      population
      |> select(opts)
      |> crossover(opts)
      |> mutation(opts)
      |> evolve(problem, generation, best_fitness, temperature, opts)
    end
  end

  defp initialize(genotype, opts \\ []) do
    population_size = get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  defp evaluate(population, fitness_function, _opts) do
    population
    |> map(fn chromosome ->
      fitness = fitness_function.(chromosome)
      age = chromosome.age + 1
      %Chromosome{chromosome | fitness: fitness, age: age}
    end)
    |> sort_by(& &1.fitness, &>=/2)
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
        cx_point = :rand.uniform(length(p1.genes))
        {{h1, t1}, {h2, t2}} = {split(p1.genes, cx_point), split(p2.genes, cx_point)}
        {c1, c2} = {%Chromosome{p1 | genes: h1 ++ t2}, %Chromosome{p2 | genes: h2 ++ t1}}
        [c1, c2 | acc]
      end
    )
  end

  defp mutation(population, _opts) do
    population
    |> map(fn chromosome ->
      if :rand.uniform() < 0.05 do
        %Chromosome{chromosome | genes: shuffle(chromosome.genes)}
      else
        chromosome
      end
    end)
  end
end
