defmodule Valuation do
  @truth_values [:t, :f]

  def new(formula, truth_value)
      when truth_value in @truth_values do
    %{formula => truth_value}
  end

  def value(valuation, atom) when is_atom(atom) do
    valuation[atom]
  end
end
