defmodule Crux.Structs.Role do
  @moduledoc """
    Represents a Discord [Role Object](https://discordapp.com/developers/docs/topics/permissions#role-object-role-structure).
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Role, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    id: nil,
    name: nil,
    color: nil,
    hoist: nil,
    position: nil,
    permissions: nil,
    managed: nil,
    mentionable: nil,
    guild_id: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          id: Crux.Rest.snowflake(),
          name: String.t(),
          color: integer(),
          hoist: boolean(),
          position: integer(),
          permissions: integer(),
          managed: boolean(),
          mentionable: boolean(),
          guild_id: Crux.Rest.snowflake()
        }

  @doc """
    Creates a `Crux.Structs.Role` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    role =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)
      |> Map.update(:guild_id, nil, &Util.id_to_int/1)

    struct(__MODULE__, role)
  end

  @doc ~S"""
    Converts a `Crux.Structs.Role` into its discord mention format.

    ## Example

    ```elixir
  iex> %Crux.Structs.Role{id: 376146940762783746}
  ...> |> Crux.Structs.Role.to_mention()
  "<@&376146940762783746>"

    ```
  """
  @spec to_mention(user :: Crux.Structs.Role.t()) :: String.t()
  Util.since("0.1.1")
  def to_mention(%__MODULE__{id: id}), do: "<@&#{id}>"

  defimpl String.Chars, for: Crux.Structs.Role do
    @spec to_string(Role.t()) :: String.t()
    def to_string(%Role{} = data), do: Role.to_mention(data)
  end
end
