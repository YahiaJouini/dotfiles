vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Redirect change operations to the black hole register
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')

-- Centered half-page scrolling
vim.keymap.set({ "n", "v" }, "<C-f>", "<C-u>zz", { desc = "Scroll half page up and center" })
vim.keymap.set({ "n", "v" }, "<C-b>", "<C-d>zz", { desc = "Scroll half page down and center" })

-- Go to start of line (Azerty layout optimization)
vim.keymap.set({ "n", "v", "o" }, "ù", "0", { desc = "Go to start of line" })

-- Disable Shift+Arrow in normal mode
vim.keymap.set("n", "<S-Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<S-Up>", "<Nop>", { silent = true })

-- Fix Shift+Arrow in visual mode
vim.keymap.set("v", "<S-Down>", "j", { desc = "Move down in visual" })
vim.keymap.set("v", "<S-Up>", "k", { desc = "Move up in visual" })

-- Toggle comments
vim.keymap.set("n", "m", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("x", "m", "gc", { remap = true, desc = "Toggle comment selection" })

-- Native regex replace (Note: <leader>S is mapped to grug-far in lazy)
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", { desc = "Replace word under cursor" })

-- Clear highlights on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Buffer-Local LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	desc = "Set buffer-local keymaps for LSP attached buffers",
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition({
				on_list = function(options)
					if not options.items or #options.items == 0 then
						vim.notify("No definition found", vim.log.levels.WARN)
						return
					end
					local first_def = options.items[1]
					vim.cmd("edit " .. vim.fn.fnameescape(first_def.filename))
					vim.api.nvim_win_set_cursor(0, { first_def.lnum, first_def.col - 1 })
					vim.cmd("normal! zz")
				end,
			})
		end, vim.tbl_extend("force", opts, { desc = "Go to Definition (Bypass QF)" }))

		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end, vim.tbl_extend("force", opts, { desc = "Format Buffer (Conform)" }))

		vim.keymap.set(
			"n",
			"gl",
			vim.diagnostic.open_float,
			vim.tbl_extend("force", opts, { desc = "Line Diagnostics" })
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code Actions" })
		)
		vim.keymap.set("n", "<leader>ce", function()
			local line = vim.api.nvim_win_get_cursor(0)[1] - 1
			local diags = vim.diagnostic.get(0, { lnum = line })
			if #diags == 0 then
				vim.notify("No diagnostic", vim.log.levels.WARN)
				return
			end

			local msg = diags[1].message
			vim.fn.setreg("+", msg)
			vim.fn.setreg('"', msg)
			vim.notify("Copied: " .. msg, vim.log.levels.INFO)
		end, vim.tbl_extend("force", opts, { desc = "Copy Error to Clipboard" }))
	end,
})
