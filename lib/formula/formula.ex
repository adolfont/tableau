defmodule Formula do
  @binary_connectives [:and, :or, :implies]
  @unary_connectives [:not]

  def new(:atomic, atom) when is_atom(atom) do
    atom
  end

  def new(connective, formula) when connective in @unary_connectives do
    {connective, formula}
  end

  def new(left_subformula, connective, right_subformula)
      when connective in @binary_connectives do
    {left_subformula, connective, right_subformula}
  end

  def well_formed_formula?(x) when is_atom(x), do: true

  def well_formed_formula?({connective, x})
      when connective in @unary_connectives,
      do: well_formed_formula?(x)

  def well_formed_formula?({x, connective, y})
      when connective in @binary_connectives,
      do: well_formed_formula?(x) and well_formed_formula?(y)

  def well_formed_formula?(_), do: false
end
