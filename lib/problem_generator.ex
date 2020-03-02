defmodule ProblemGenerator do
  def php_t_aux(n) do
    for i <- 0..n do
      for j <- 0..(n - 1) do
        String.to_atom("p#{i}#{j}")
      end
    end
  end

  def list_to_or([head]) do
    head
  end

  def list_to_or([head | tail]) do
    {head, :or, list_to_or(tail)}
  end

  def first_part(n) do
    for x <- php_t_aux(n) do
      {:t, list_to_or(x)}
    end
  end

  def second_part(n) do
    for i <- 0..(n - 1) do
      for j <- 0..n do
        for k <- min(n, j + 1)..n do
          if not (j == k) do
            left = String.to_atom("p#{j}#{i}")
            right = String.to_atom("p#{k}#{i}")
            {:f, {left, :and, right}}
          end
        end
      end
    end
    |> List.flatten()
    |> Enum.reject(fn x -> x == nil end)
  end

  def php(1) do
    [
      {:t, :p00},
      {:t, :p01},
      {:f, {:p00, :and, :p01}}
    ]
  end

  def php(n) do
    first_part(n) ++ second_part(n)
  end
end
