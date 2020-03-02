defmodule Tableau do
  import Proof

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

  @doc """

  Apply a linear rule to a signed formula.

  Returns the set of conclusions.

  ## Examples

      iex> Tableau.apply_linear({:t, {:not, :p}})
      [{:f, :p}]
      iex> Tableau.apply_linear({:f, {:not, :p}})
      [{:t, :p}]
      iex> Tableau.apply_linear({:t, {:p, :and, :q}})
      [{:t, :p}, {:t, :q}]


  """
  def apply_linear(signed_formula)

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

  @doc """

  Apply all linear rules to a list of signed formulas.

  Returns the set of conclusions.

  ## Examples

    iex(1)> Tableau.apply_all_linear_recursively([{:t, {:not, :p}}])
    [t: {:not, :p}, f: :p]

    iex(1)> Tableau.apply_all_linear_recursively([{:t, {:not, {:not, :a}}}, {:t, {:c, :and, {:d, :and, :g}}}, {:f, {:u, :and, :u}}])
    [
      t: {:not, {:not, :a}},
      t: {:c, :and, {:d, :and, :g}},
      f: {:u, :and, :u},
      f: {:not, :a},
      t: :c,
      t: {:d, :and, :g},
      t: :a,
      t: :d,
      t: :g
    ]

  """
  def apply_all_linear_recursively(formulas) do
    apply_all_linear_recursively_aux(formulas, [])
  end

  def apply_all_linear_once(formulas) do
    formulas |> Enum.map(&Tableau.apply_linear/1) |> List.flatten() |> Enum.dedup()
  end

  def attempt_to_close(proof = %Proof{}) do
    if Closing.is_closed?(proof.formulas) do
      %{proof | status: :closed}
    else
      proof
    end
  end

  def prove(formulas) do
    prove_aux(%Proof{formulas: formulas})
  end

  def apply_linear_rules(proof = %Proof{}) do
    %{proof | formulas: apply_all_linear_recursively(proof.formulas)}
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

  def branch_if_not_closed(proof = %Proof{status: :closed}) do
    proof
  end

  def branch_if_not_closed(proof) do
    apply_branching_rule(proof, get_branching_formulas(proof.formulas))
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

  def expand_with_branching_rule(proof, _, _) do
    proof
  end

  def prove_aux(proof) do
    proof
    |> apply_linear_rules()
    |> attempt_to_close()
    |> branch_if_not_closed()
  end
end

# Tableau.prove([{:t, {:not, {:not, :a}}}, {:t, {:a, :implies, :b}}, {:f, :b}])
# |> IO.inspect()

# Tableau.prove([{:t, {:not, {:not, :b}}}, {:t, {:a, :implies, :b}}, {:f, :b}])
# |> IO.inspect()
