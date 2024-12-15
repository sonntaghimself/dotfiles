return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["html"] = { "prettier" },
        ["javascript"] = { "prettier" },
        ["python"] = { "ruff" },
        ["r"] = { "jupytext" },
      },
    },
  },
}
