local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end

	return false
end

local packer_bootstrap = ensure_packer()

-- Auto-sync plugins when we save the plugins file
vim.cmd([[
	augroup packer_user_config
		autocmd!
		autocmd BufWritePost plugins.lua source <afile> | PackerSync
	augroup end
]])

local packer_installed, packer = pcall(require, "packer")
if not packer_installed then
	return
end

-- have packer use a floating window instead of sidebar
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({
				border = "rounded",
				style = "minimal",
			})
		end,
	},
})

return packer.startup(function(use)
	-- Packer is magic and can manage itself
	use("wbthomason/packer.nvim")

	-- Funcs needed by many plugins
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")

	-- Theming
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
	use("nvim-tree/nvim-web-devicons")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("mvllow/modes.nvim")
	use("goolord/alpha-nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("rcarriga/nvim-notify")

	-- Statusline
	use("akinsho/bufferline.nvim")
	use("nvim-lualine/lualine.nvim")
	use("nanozuki/tabby.nvim")
	use({
		"utilyre/barbecue.nvim",
		tag = "*",
		requires = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		after = "nvim-web-devicons",
		config = function()
			require("barbecue").setup()
		end,
	})

	-- Git plugins
	use("kdheepak/lazygit.nvim")
	use("lewis6991/gitsigns.nvim")
	use("akinsho/git-conflict.nvim")

	-- General workflow
	use({
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true, -- defaults to false
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					last_active = "<C-\\>",
					next = "<C-Space>",
				},
			})
		end,
	})
	use("NvChad/nvim-colorizer.lua")
	use("folke/todo-comments.nvim")
	use("folke/trouble.nvim")
	use("folke/which-key.nvim")
	use("numToStr/Comment.nvim")
	use("nvim-tree/nvim-tree.lua")
	use("roobert/tailwindcss-colorizer-cmp.nvim")
	use("windwp/nvim-autopairs")
	use("simrat39/symbols-outline.nvim")
	use("nvim-treesitter/nvim-tree-docs")
	use({
		"danymat/neogen",
		config = function()
			require("neogen").setup({})
		end,
	})

	-- Telescope
	use("nvim-telescope/telescope-file-browser.nvim")
	use("nvim-telescope/telescope-packer.nvim")
	use("nvim-telescope/telescope-project.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- improves sorting perf
	use({ "nvim-telescope/telescope.nvim", tag = "0.1.0" })

	-- LSP and Formatting
	use("RRethy/vim-illuminate")
	use("RubixDev/mason-update-all")
	use("glepnir/lspsaga.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("neovim/nvim-lspconfig")
	use("nvim-lua/lsp-status.nvim")
	use("onsails/lspkind.nvim")
	use("simrat39/rust-tools.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("williamboman/mason.nvim")

	-- Autocompletion
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/vim-vsnip")
	use("saadparwaiz1/cmp_luasnip")

	-- Snippets
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")

	-- Debugger
	use("mfussenegger/nvim-dap")
	use("mxsdev/nvim-dap-vscode-js")
	use("rcarriga/nvim-dap-ui")
	use("theHamsta/nvim-dap-virtual-text")
	use("nvim-telescope/telescope-dap.nvim")
	use({
		"microsoft/vscode-js-debug",
		opt = true,
		run = "npm install --legacy-peer-deps && npm run compile",
		tag = "v1.74.1", -- you *must* specify this tag; newer versions have breaking bugs
	})

	-- Additional languages
	use("digitaltoad/vim-pug")
	use("pearofducks/ansible-vim")
	use("hashivim/vim-terraform")

	if packer_bootstrap then
		require("packer").sync()
	end
end)
