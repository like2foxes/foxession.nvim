local M = {}

local _config = {
	session_dir = vim.fn.stdpath('data') .. '/sessions/',
	session_full_path = "",
	auto_save = false,
	initizalized = false,
	keys = {
		save_session = '<leader>ps',
		load_session = '<leader>pl',
		list_sessions = '<leader>pa',
	},
}

--@return boolean: true if a session is loaded, false otherwise
local session_is_loaded = function()
	local current_session = vim.v.this_session
	if current_session ~= nil and current_session ~= "" then
		return true
	end
	return false
end

local set_auto_write_session = function()
	vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
		group = vim.api.nvim_create_augroup('foxession_auto_save', { clear = true }),
		pattern = { '*' },
		callback = function()
			vim.notify("Saving session")
			M.save_session()
		end,
	})
end

local ensure_session_dir_exist = function()
	local stat, err, err_name = vim.uv.fs_stat(_config.session_dir)

	if not stat then
		if err ~= nil then
			vim.notify("Error checking session directory: " .. err_name .. " " .. err, "error")
			return
		end
		local ok, err, err_name = vim.uv.fs_mkdir(_config.session_dir, 511)
		if not ok then
			vim.notify("Error creating session directory: " .. err_name .. " " .. err, "error")
			return
		end
	end
	return true
end

local merge_configs = function(config)
	if config.session_dir ~= nil then
		_config.session_dir = config.session_dir
	end

	if config ~= nil and config.keys ~= nil then
		for key, value in pairs(config.keys) do
			if config.keys[key] ~= nil then
				_config.keys[key] = value
			end
		end
	end

	if config.auto_save ~= nil then
		_config.auto_save = config.auto_save
	end
end

local session_exist = function()
	local stat, err, err_name = vim.uv.fs_stat(_config.session_full_path)
	if not stat then
		return false
	end
	return true
end

---@param config table configuration table
M.setup = function(config)
	merge_configs(config)
	local dir_ok = ensure_session_dir_exist()
	if not dir_ok then
		return
	end

	vim.keymap.set('n', _config.keys.save_session, M.save_session,
		{ noremap = true, silent = true, desc = "Save session" })
	vim.keymap.set('n', _config.keys.load_session, M.load_session,
		{ noremap = true, silent = true, desc = "Load session" })
	vim.keymap.set('n', _config.keys.list_sessions, M.list_sessions,
		{ noremap = true, silent = true, desc = "List sessions" })

	_config.initialized = true
end

M.save_session = function()
	if not _config.initialized then
		vim.notify("foxession not initialized", "error")
		return
	end
	if session_is_loaded() then
		vim.cmd.mksession({ args = { vim.v.this_session }, bang = true })
		vim.notify("session saved", "info")
		return
	end
	vim.ui.input({
			prompt = "Enter session name: " },
		function(name)
			if name ~= nil then
				local curname = _config.session_full_path
				_config.session_full_path = _config.session_dir .. name .. ".vim"
				if session_exist() then
					vim.ui.input(
						{
							prompt = "Session already exists. Overwrite? (y/n)" },
						function(answer)
							if answer == "y" then
								vim.cmd.mksession({ args = { vim.fs.normalize(_config.session_full_path) }, bang = true })
								vim.notify("session saved", "info")
							else
								_config.session_full_path = curname
								return
							end
						end
					)
				else
					vim.cmd.mksession({ args = { _config.session_full_path }, bang = true })
					vim.notify("session saved", "info")
				end
				if _config.auto_save then
					set_auto_write_session()
				end
			end
		end
	)
end

M.load_session = function()
	if not _config.initialized then
		vim.notify("foxession not initialized", "error")
		return
	end
	vim.ui.input({ prompt = "Enter session name: " },
		function(name)
			if name ~= nil then
				local curname = _config.session_full_path
				_config.session_full_path = vim.trim(_config.session_dir .. name) .. ".vim"
				if not session_exist() then
					vim.notify("Session not found", "warn")
					_config.session_full_path = curname
				else
					vim.cmd.source(_config.session_full_path)
				end
			end
		end
	)
end

M.list_sessions = function()
	if not _config.initialized then
		vim.notify("foxession not initialized", "error")
		return
	end
	local sessions = vim.fn.glob(_config.session_dir .. '*.vim', true, true)
	if #sessions == 0 then
		vim.notify("No sessions found", "warn")
		return
	end
	vim.ui.select(sessions, {
			prompt = "Select session: ",
			---@type fun(item: string): string
			format_item = function(item)
				vim.notify(item)
				return item:match(".*[/|\\](.*)%.vim$") or item
			end

		},
		function(selected, idx)
			if idx ~= nil then
				_config.session_full_path = selected
				vim.cmd.source(selected)
			end
		end
	)
end

return M
