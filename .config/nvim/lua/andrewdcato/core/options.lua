local options = {
	-- base ui config
	guifont = { "JetBrainsMono Nerd Font", "h15" },
	relativenumber = true,
	number = true,
	showmatch = true,
	colorcolumn = "120",
	termguicolors = true,
	background = "dark", -- force dark mode in themes that support it
	signcolumn = "yes",
	smartindent = true,
	backspace = "indent,eol,start",
	scrolloff = 8, -- keep X lines around the cursor at all times
	pumblend = 0,
	winblend = 0,
	showmode = false,
	cursorline = false,
	-- text wrapping
	textwidth = 0,
	wrapmargin = 0,
	wrap = true,
	linebreak = true,
	-- spacing
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true, -- convert tabs to spaces like a civilized person
	-- search tweaks
	ignorecase = true, -- make search case-insensitive
	smartcase = true, -- make search case-sensitive when starting w/capitals
	-- completeopt settings
	completeopt = { "menuone", "noselect", "noinsert" },
	shortmess = vim.opt.shortmess + { c = true },
	-- modeline
	modeline = true,
	modelines = 5,
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

-- Clipboard
vim.opt.clipboard:append("unnamedplus") -- use the system clipboard when yanking text

-- Misc
vim.opt.guicursor = "a:block-Cursor" -- block cursor in all modes
vim.opt.guicursor = "i-v:blinkon10" -- blink the cursor in insert or visual mode
vim.opt.iskeyword:append("-") -- changes the "-" character to be considered part of the word

vim.api.nvim_set_option("updatetime", 300)

-- Use nvim-notify as default for notifications
local notify_ok, notify = pcall(require, "notify")
if notify_ok then
	notify.setup({
		background_color = "#000000",
		render = "compact",
		fps = 60,
	})

	vim.notify = notify
end
