defmodule Proof do
  defstruct status: :open, branches: [], formulas: []

  def add_branches(proof, left, right) do
    left_branch = %Proof{proof | formulas: proof.formulas ++ [left]}
    right_branch = %Proof{proof | formulas: proof.formulas ++ [right]}
    %Proof{proof | branches: [left_branch, right_branch]}
  end
end
