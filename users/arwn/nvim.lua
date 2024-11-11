vim.opt.number = true

local lspconfig = require('lspconfig')

lspconfig['tsserver'].setup {
	highlight = {
		enable = true,
	}
}
