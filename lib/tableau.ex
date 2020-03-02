defmodule Tableau do
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

  def branch_if_not_closed(proof = %Proof{status: :closed}) do
    proof
  end

  def branch_if_not_closed(proof) do
    Branching.apply_branching_rule(proof, Branching.get_branching_formulas(proof.formulas))
  end

  defp prove_aux(proof) do
    proof
    |> Linear.apply_linear_rules()
    |> attempt_to_close()
    |> branch_if_not_closed()
    |> Branching.prove_branches()
  end

  def prove(formulas) do
    prove_aux(%Proof{formulas: formulas})
  end
end
