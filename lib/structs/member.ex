defmodule Crux.Structs.Member do
  @moduledoc """
    Represents a Discord [Guild Member Object](https://discordapp.com/developers/docs/resources/guild#guild-member-object-guild-member-structure).

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Member, Util}
  require Util

  Util.modulesince("0.1.0")

  defstruct(
    user: nil,
    nick: nil,
    roles: nil,
    joined_at: nil,
    deaf: nil,
    mute: nil,
    guild_id: nil
  )

  Util.typesince("0.1.0")

  @type t :: %__MODULE__{
          user: Crux.Rest.snowflake(),
          nick: String.t() | nil,
          roles: MapSet.t(Crux.Rest.snowflake()),
          joined_at: String.t(),
          deaf: boolean() | nil,
          mute: boolean() | nil,
          guild_id: Crux.Rest.snowflake() | nil
        }

  @doc """
    Creates a `Crux.Structs.Member` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.0")

  def create(data) do
    member =
      data
      |> Util.atomify()
      |> Map.update!(:user, Util.map_to_id())
      |> Map.update!(:roles, &MapSet.new(&1, fn role_id -> Util.id_to_int(role_id) end))
      |> Map.update(:guild_id, nil, &Util.id_to_int/1)

    struct(__MODULE__, member)
  end

  @doc ~S"""
    Converts a `Crux.Structs.Member` into its discord mention format.

  ## Examples

    ```elixir
  # Without nickname
  iex> %Crux.Structs.Member{user: 218348062828003328, nick: nil}
  ...> |> Crux.Structs.Member.to_mention()
  "<@218348062828003328>"

  # With nickname
  iex> %Crux.Structs.Member{user: 218348062828003328, nick: "weltraum"}
  ...> |> Crux.Structs.Member.to_mention()
  "<@!218348062828003328>"

    ```
  """
  @spec to_mention(user :: Crux.Structs.Member.t()) :: String.t()
  Util.since("0.1.1")
  def to_mention(%__MODULE__{user: id, nick: nil}), do: "<@#{id}>"
  def to_mention(%__MODULE__{user: id}), do: "<@!#{id}>"

  defimpl String.Chars, for: Crux.Structs.Member do
    @spec to_string(Member.t()) :: String.t()
    def to_string(%Member{} = data), do: Member.to_mention(data)
  end
end
