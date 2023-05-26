local treesitter_installed, treesitter = pcall(require, "nvim-treesitter.configs")
if not treesitter_installed then
	return
end

local parsers = {
	"bash",
	"css",
	"dockerfile",
	"hcl",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"prisma",
	"pug",
	"rust",
	"toml",
	"terraform",
	"typescript",
	"vim",
	"yaml",
}

return treesitter.setup({
	auto_install = true,
	ensure_installed = parsers,
	highlight = { enabled = true }, -- enable extension
	indentation = { enabled = true },
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
	sync_install = false, -- force async install
	tree_docs = { enable = true },
})
