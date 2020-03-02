defmodule Linear do
  @doc """

  Apply a linear rule to a signed formula.

  Returns a list of conclusions.

  ## Examples

      iex> Linear.apply_linear({:t, {:not, :p}})
      [{:f, :p}]
      iex> Linear.apply_linear({:f, {:not, :p}})
      [{:t, :p}]
      iex> Linear.apply_linear({:t, {:p, :and, :q}})
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

  Apply all linear rules recursively to a list of signed formulas.

  Returns a list containing the signed formulas and the  conclusions.

  ## Examples

      iex> Linear.apply_all_linear_recursively([{:t, {:not, :p}}])
      [t: {:not, :p}, f: :p]

      iex> Linear.apply_all_linear_recursively([{:t, {:not, {:not, :a}}}, {:t, {:c, :and, {:d, :and, :g}}}, {:f, {:u, :and, :u}}])
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
  def apply_all_linear_recursively(signed_formulas) do
    apply_all_linear_recursively_aux(signed_formulas, [])
  end

  @doc """

  Apply all linear rules to a list of signed formulas.

  Returns a list containing the conclusions.
  """
  def apply_all_linear_once(formulas) do
    formulas |> Enum.map(&apply_linear/1) |> List.flatten() |> Enum.uniq()
  end

  def apply_linear_rules(proof = %Proof{}) do
    %{proof | formulas: Enum.uniq(apply_all_linear_recursively(proof.formulas))}
  end
end
