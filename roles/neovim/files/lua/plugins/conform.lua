return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			go = { "goimports", "gofumpt" },
			terraform = { "terraform_fmt" },
			yaml = { "prettier" },
			["yaml.ansible"] = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
