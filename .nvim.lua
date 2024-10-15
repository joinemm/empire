require("lspconfig").nixd.setup({
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import (builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs { }',
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixos = {
          expr =
          'let flake = builtins.getFlake ("git+file://" + toString ./.); in flake.nixosConfigurations.rome.options // flake.nixosConfigurations.athens.options',
        },
        flake_parts = {
          expr =
          'let flake = builtins.getFlake ("git+file://" + toString ./.); in flake.debug.options // flake.currentSystem.options',
        },
      },
    },
  },
})
