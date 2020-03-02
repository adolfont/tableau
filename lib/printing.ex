defmodule Printing do
  def show_proof(proof = %Proof{}) do
    IO.puts("FORMULAS: ")
    Enum.map(proof.formulas, &show_signed_formula(&1))
    IO.puts("STATUS: #{proof.status}")
    IO.inspect(proof.branches)
    # show_proof_branches(proof.branches)
  end

  # defp show_proof_branches([]) do
  # end

  defp show_signed_formula({sign, formula}) do
    IO.puts("#{sign_as_string(sign)} #{formula_as_string(formula)}")
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
