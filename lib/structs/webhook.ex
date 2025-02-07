defmodule Crux.Structs.Webhook do
  @moduledoc """
    Represents a Discord [Webhook Object](https://discordapp.com/developers/docs/resources/webhook#webhook-object)

  Differences opposed to the Discord API Object:
    - `:user` is just the user id
  """

  @behaviour Crux.Structs

  alias Crux.Structs.{Util, Webhook}
  require Util

  Util.modulesince("0.1.6")

  defstruct(
    avatar: nil,
    channel_id: nil,
    guild_id: nil,
    id: nil,
    name: nil,
    token: nil,
    user: nil
  )

  Util.typesince("0.1.6")

  @type t :: %__MODULE__{
          avatar: String.t() | nil,
          id: Crux.Rest.snowflake(),
          channel_id: Crux.Rest.snowflake(),
          guild_id: Crux.Rest.snowflake() | nil,
          name: String.t() | nil,
          token: String.t(),
          user: Crux.Rest.snowflake() | nil
        }

  @doc """
    Creates a `Crux.Structs.Webhook` struct from raw data.

  > Automatically invoked by `Crux.Structs.create/2`.
  """
  @spec create(data :: map()) :: t()
  Util.since("0.1.6")

  def create(data) do
    data =
      data
      |> Util.atomify()
      |> Map.update!(:id, &Util.id_to_int/1)
      |> Map.update!(:channel_id, &Util.id_to_int/1)
      |> Map.update(:guild_id, nil, &Util.id_to_int/1)
      |> Map.update(:user, nil, Util.map_to_id())

    struct(__MODULE__, data)
  end

  @doc ~S"""
    Converts a `Crux.Structs.Webhook` into its discord mention format.

  > Although the discord client does not autocomplete it for you, mentioning one still works.

    ```elixir
  iex> %Crux.Structs.Webhook{id: 218348062828003328}
  ...> |> Crux.Structs.Webhook.to_mention()
  "<@218348062828003328>"

    ```
  """
  @spec to_mention(webhook :: Crux.Structs.Webhook.t()) :: String.t()
  Util.since("0.1.6")
  def to_mention(%__MODULE__{id: id}), do: "<@#{id}>"

  defimpl String.Chars, for: Crux.Structs.Webhook do
    @spec to_string(Webhook.t()) :: String.t()
    def to_string(%Webhook{} = data), do: Webhook.to_mention(data)
  end
end
