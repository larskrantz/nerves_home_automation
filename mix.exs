defmodule NervesHomeAutomation.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi2"

  def project do
    [app: :nerves_home_automation,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "0.1.3"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(Mix.env),
     deps: deps ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.

  def application do
    [mod: {NervesHomeAutomation, []},
     applications: applications(Mix.env)]
  end

  def applications(:prod) do
    [:nerves, :elixir_ale] ++ applications(:all)
  end
  def applications(_), do: [:logger]

  def deps do
    [
      {:nerves, "~> 0.3.0"},
      {:elixir_ale, "~> 0.5.2", only: [:prod]}
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases(:prod) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

  def aliases(_), do: []

end
