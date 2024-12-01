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

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{ 'like2foxes/foxession.nvim', }
```

---

## Configuration

Foxession will use the following defaults:

```lua
opts = {
    session_dir = vim.fn.stdpath('data') .. '/sessions/', -- Directory for storing sessions
    auto_save = false,                                   -- Disable auto-save by default
    keys = {
        save_session = '<leader>ps',                     -- Save session
        load_session = '<leader>pl',                     -- Load session
        list_sessions = '<leader>pa',                    -- List available sessions
    }
```

### Keybindings

- `<leader>ps`: Save the current session.
- `<leader>pl`: Load a previously saved session.
- `<leader>pa`: List all saved sessions interactively and pick the one to load.

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
