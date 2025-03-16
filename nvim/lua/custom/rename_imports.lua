local function rename_file_and_update_imports(old_name, new_name)
	-- Step 1: Rename the file
	local rename_cmd = string.format("mv %s %s", old_name, new_name)
	os.execute(rename_cmd)

	-- Step 2: Search and replace import paths in the project
	local search_cmd = string.format("grep -rl '%s' . | xargs sed -i 's|%s|%s|g'", old_name, old_name, new_name)
	os.execute(search_cmd)

	-- Step 3: Use LSP to update references (if supported)
	if vim.lsp.buf.server_capabilities().renameProvider then
		vim.lsp.buf.rename(new_name)
	else
		print("LSP does not support renaming imports automatically.")
	end

	print(string.format("Renamed %s to %s and updated imports.", old_name, new_name))
end

local function prompt_rename()
	local old_name = vim.fn.input("Old file name: ")
	local new_name = vim.fn.input("New file name: ")
	rename_file_and_update_imports(old_name, new_name)
end

vim.keymap.set("n", "<leader>rp", prompt_rename, { noremap = true, silent = true })
