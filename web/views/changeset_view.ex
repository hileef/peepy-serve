defmodule Peepy.ChangesetView do
  use Peepy.Web, :view

  # See `Ecto.Changeset.traverse_errors/2` and `Peepy.ErrorHelpers.translate_error/1`

  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    JaSerializer.EctoErrorSerializer.format(changeset)
  end

end
