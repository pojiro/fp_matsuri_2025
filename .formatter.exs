# Used by "mix format"
[
  import_deps: [:phoenix],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "rootfs_overlay/etc/iex.exs"
  ]
]
