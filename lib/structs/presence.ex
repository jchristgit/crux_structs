defmodule Crux.Structs.Presence do
  @moduledoc """
    Represents a Discord [Presence Object](https://discordapp.com/developers/docs/topics/gateway#presence-update-presence-update-event-fields).
  """
  alias Crux.Structs.Util

  defstruct(
    user: nil,
    # roles: [],
    game: nil,
    # guild_id: nil,
    status: "offline"
  )

  @type t :: %__MODULE__{
          user: integer(),
          # roles: [integer()],
          game: map() | nil,
          # guild_id: integer() | nil,
          status: String.t()
        }

  @doc false
  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:user, fn user -> Map.get(user, :id) |> Util.id_to_int() end)

    struct(__MODULE__, data)
  end
end
