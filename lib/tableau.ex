defmodule Tableau do
  import Proof

  def apply_linear({:t, {:not, formula}}) do
    [{:f, formula}]
  end

  def apply_linear({:f, {:not, formula}}) do
    [{:t, formula}]
  end

  def apply_linear({:t, {left, :and, right}}) do
    [{:t, left}, {:t, right}]
  end

  def apply_linear({:f, {left, :or, right}}) do
    [{:f, left}, {:f, right}]
  end

  def apply_linear({:f, {left, :implies, right}}) do
    [{:t, left}, {:f, right}]
  end

  def apply_linear(_) do
    []
  end

  defp apply_all_linear_recursively_aux([], result) do
    result
  end

  defp apply_all_linear_recursively_aux(formulas, result) do
    apply_all_linear_recursively_aux(
      apply_all_linear_once(formulas),
      result ++ formulas
    )
  end

  def apply_all_linear_recursively(formulas) do
    apply_all_linear_recursively_aux(formulas, [])
  end

  def apply_all_linear_once(formulas) do
    formulas |> Enum.map(&Tableau.apply_linear/1) |> List.flatten() |> Enum.dedup()
  end
end

# example = [{:t, :a}, {:t, {:a, :implies, :b}}, {:f, :b}]
# proof = %Proof{formulas: example}

# IO.inspect(proof)
