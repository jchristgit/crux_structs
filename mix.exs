defmodule Crux.Structs.MixProject do
  use Mix.Project

  @vsn "0.2.0"
  @name :crux_structs

  def project do
    [
      start_permanent: Mix.env() == :prod,
      package: package(),
      app: @name,
      version: @vsn,
      elixir: "~> 1.6",
      description: "Package providing Discord API structs for crux.",
      source_url: "https://github.com/SpaceEEC/crux_structs/",
      homepage_url: "https://github.com/SpaceEEC/crux_structs/",
      deps: deps(),
      aliases: aliases()
    ]
  end

  def package do
    [
      name: @name,
      licenses: ["MIT"],
      maintainers: ["SpaceEEC"],
      links: %{
        "GitHub" => "https://github.com/SpaceEEC/#{@name}/",
        "Changelog" => "https://github.com/SpaceEEC/#{@name}/releases/tag/#{@vsn}/",
        "Documentation" => "https://hexdocs.pm/#{@name}/#{@vsn}",
        "Unified Development Documentation" => "https://crux.randomly.space/"
      }
    ]
  end

  def application, do: []

  defp deps do
    [
      {:ex_doc,
       git: "https://github.com/spaceeec/ex_doc",
       branch: "feat/umbrella",
       only: :dev,
       runtime: false},
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:poison, ">= 0.0.0", only: [:dev]}
    ]
  end

  defp aliases() do
    [
      docs: ["docs", &generate_config/1]
    ]
  end

  def generate_config(_) do
    config =
      System.cmd("git", ["tag"])
      |> elem(0)
      |> String.split("\n")
      |> Enum.slice(0..-2)
      |> Enum.map(&%{"url" => "https://hexdocs.pm/#{@name}/" <> &1, "version" => &1})
      |> Enum.reverse()
      |> Poison.encode!()

    config = "var versionNodes = " <> config

    __ENV__.file
    |> Path.split()
    |> Enum.slice(0..-2)
    |> Kernel.++(["doc", "docs_config.js"])
    |> Enum.join("/")
    |> File.write!(config)

    Mix.Shell.IO.info(~S{Generated "doc/docs_config.js".})
  end
end
