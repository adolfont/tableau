defmodule Tableau do
  import Proof
  import Printing
  import Linear

  @moduledoc """
    Module that implements Analytic Tableaux.

    Formulas are represented as:

    - Atomic formulas: `:p, :q, :r`
    - Negation (not): `{:not, :p}, {:not, {:not, :p}}`
    - Conjunction (and): `{:p, :and, :q}`
    - Disjunction (or): `{:p, :or, :q}`
    - Implication (if-then): `{:p, :implies, :q}`


  Signed formulas are represented as a tuple containing a sign (true `:t` or false `:f`) and a formula:
    - `{:f,  {:p, :implies, :q}}`
    - `{:t,  {:p, :implies, :q}}`
  """

  defp attempt_to_close(proof = %Proof{}) do
    if Closing.is_closed?(proof.formulas) do
      %{proof | status: :closed}
    else
      proof
    end
  end

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
    apply_beta(first_branching_formula)

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

  defp expand_with_branching_rule(proof, _, _) do
    proof
  end

  defp prove_branches(proof = %Proof{}) do
    show_proof(proof)
  end

  defp branch_if_not_closed(proof = %Proof{status: :closed}) do
    proof
  end

  defp branch_if_not_closed(proof) do
    apply_branching_rule(proof, get_branching_formulas(proof.formulas))
  end

  defp prove_aux(proof) do
    proof
    |> apply_linear_rules()
    |> attempt_to_close()
    |> branch_if_not_closed()
    |> prove_branches()
  end

  def prove(formulas) do
    prove_aux(%Proof{formulas: formulas})
  end
end

Tableau.prove([{:t, {:not, {:not, :a}}}, {:t, {:a, :implies, :b}}, {:f, :b}])

# |> IO.inspect()

Tableau.prove([{:t, {:not, {:not, :b}}}, {:t, {:a, :implies, :b}}, {:f, :b}])
# |> IO.inspect()
