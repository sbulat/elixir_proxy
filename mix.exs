defmodule KeenProxy.MixProject do
  use Mix.Project

  def project do
    [
      app: :keen_proxy,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {KeenProxy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0.1"},
      {:plug, "~> 1.8.2"},
      {:plug_cowboy, "~> 2.0"},
      {:cowboy, "~> 2.7"},
      {:httpoison, "~> 1.6"},
      {:nebulex, "~> 1.1.0"}
    ]
  end
end
