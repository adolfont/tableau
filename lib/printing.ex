defmodule Printing do
  def show_proof(proof = %Proof{branches: []}) do
    ["FORMULAS: ", Enum.map(proof.formulas, &show_signed_formula(&1)), "STATUS: #{proof.status}"]
    # show_proof_branches(proof.branches)
  end

  def show_proof(proof = %Proof{}) do
    [
      :formulas,
      Enum.map(proof.formulas, &show_signed_formula(&1)),
      "STATUS: #{proof.status}",
      :branches,
      show_proof(hd(proof.branches)),
      show_proof(hd(tl(proof.branches)))
    ]

    # show_proof_branches(proof.branches)
  end

  # defp show_proof_branches([]) do
  # end

  defp show_signed_formula({sign, formula}) do
    "#{sign_as_string(sign)} #{formula_as_string(formula)}"
  end

  defp sign_as_string(sign) do
    sign
    |> Atom.to_string()
    |> String.upcase()
  end

  defp formula_as_string(atom) when is_atom(atom), do: Atom.to_string(atom)
  defp formula_as_string({:not, f}), do: "!#{formula_as_string(f)}"
  defp formula_as_string({f, :and, g}), do: "(#{formula_as_string(f)}&#{formula_as_string(g)})"
  defp formula_as_string({f, :or, g}), do: "(#{formula_as_string(f)}|#{formula_as_string(g)})"

  defp formula_as_string({f, :implies, g}),
    do: "(#{formula_as_string(f)}->#{formula_as_string(g)})"
end
