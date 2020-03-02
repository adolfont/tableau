defmodule Branching do
  defp branching_formula_filter({:t, {_, :or, _}}) do
    true
  end

  defp branching_formula_filter({:f, {_, :and, _}}) do
    true
  end

  defp branching_formula_filter({:t, {_, :implies, _}}) do
    true
  end

  defp branching_formula_filter(_), do: false

  def get_branching_formulas(formulas) do
    Enum.filter(formulas, &branching_formula_filter/1)
  end

  def apply_branching_rule(proof, []) do
    proof
  end

  def apply_branching_rule(proof, [
        first_branching_formula
        | remaining_branching_formulas
      ]) do
    expand_with_branching_rule(
      proof,
      apply_beta(first_branching_formula),
      remaining_branching_formulas
    )
  end

  defp apply_beta({:t, {left, :or, right}}) do
    [{:t, left}, {:t, right}]
  end

  defp apply_beta({:f, {left, :and, right}}) do
    [{:f, left}, {:f, right}]
  end

  defp apply_beta({:t, {left, :implies, right}}) do
    [{:f, left}, {:t, right}]
  end

  defp expand_with_branching_rule(proof, [left, right], _) do
    Proof.add_branches(proof, left, right)
  end
end
