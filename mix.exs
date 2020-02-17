defmodule Sesopenko.MixProject do
  use Mix.Project

  def project do
    [
      app: :sesopenko_diamond_square,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "Diamond Square algorithm fractal genration library implemented in Elixir"
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "sesopenko_diamond_square",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["GNU-GPLv3"],
      links: %{"GitHub" => "https://github.com/sesopenko/sesopenko_diamond_square"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
