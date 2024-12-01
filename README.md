Let me first review the contents of the uploaded file and then draft a proper README for your Neovim plugin.

Based on the initial review of the file, it seems like this Neovim plugin is designed to manage session files efficiently. Here's a draft of the README file for your plugin:

---

# Foxession.nvim

**Foxession.nvim** is a Neovim plugin for managing sessions with simplicity and flexibility. It allows you to save, load, and list sessions, along with optional auto-save functionality to streamline your workflow.

---

## Features

- Save the current session with a single keybinding.
- Load a previously saved session easily.
- List all available sessions interactively.
- Auto-save sessions on buffer writes or entry.

---

## Installation

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

Add the following to your `init.lua` or `init.vim`:

```lua
use {
    'yourusername/foxession.nvim',
    config = function()
        require('foxession').setup({
            session_dir = vim.fn.stdpath('data') .. '/sessions/', -- Customize session directory
            auto_save = true,                                    -- Enable auto-save
        })
    end
}
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
require('lazy').setup({
    'yourusername/foxession.nvim',
    config = function()
        require('foxession').setup({
            session_dir = vim.fn.stdpath('data') .. '/sessions/',
            auto_save = true,
        })
    end
})
```

---

## Configuration

Foxession.nvim can be configured using the `setup` function. Below are the default options:

```lua
require('foxession').setup({
    session_dir = vim.fn.stdpath('data') .. '/sessions/', -- Directory for storing sessions
    auto_save = false,                                   -- Disable auto-save by default
    keys = {
        save_session = '<leader>ps',                     -- Save session
        load_session = '<leader>pl',                     -- Load session
        list_sessions = '<leader>pa',                    -- List available sessions
    },
})
```

### Keybindings

- `<leader>ps`: Save the current session.
- `<leader>pl`: Load a session from the saved list.
- `<leader>pa`: List all saved sessions interactively.

---

## Usage

1. **Save a session**: Press `<leader>ps` to save the current session.
2. **Load a session**: Press `<leader>pl` to load a saved session.
3. **List sessions**: Press `<leader>pa` to view and select a session interactively.

---

## Auto-Save

To enable auto-saving of sessions on buffer writes or entry, set the `auto_save` option to `true` in the configuration:

```lua
require('foxession').setup({
    auto_save = true,
})
```

---

## Requirements

- Neovim 0.7+  
- Lua support enabled in Neovim  

---

## License

This plugin is licensed under the MIT License.

---

If there are additional features or clarifications needed based on the complete script, let me know!
