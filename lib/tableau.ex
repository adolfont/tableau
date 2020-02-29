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

  def  branch_if_not_closed(proof = %Proof{status: :closed}) do
    proof
  end

  def  branch_if_not_closed(proof) do
    branching_formulas = get_branching_formulas(proof.formulas)
    proof
  end

  def prove_aux(proof) do
    proof
    |> apply_linear_rules()
    |> attempt_to_close()
    |> branch_if_not_closed()
  end
end

Tableau.prove([{:t, {:not, {:not, :a}}}, {:t, {:a, :implies, :b}}, {:f, :b}])
|> IO.inspect()

Tableau.prove([{:t, {:not, {:not, :b}}}, {:t, {:a, :implies, :b}}, {:f, :b}])
|> IO.inspect()
