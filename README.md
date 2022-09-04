# floatingedit-nvim

Lua plugin for editing files in a floating window.

## Requirements:
Should be compatible with ```neovim 0.4```.

Built and used on ```neovim 0.7```.

## Features:
- Command ```Fe <path/to/file>``` to open a floating window
- Works on absolute paths, relative paths (semi stable) and NERDTree Nodes
- Add this to ```init.lua```.

```lua
vim.keymap.set(
        'n', 
        '<leader>f', 
        function() 
        vim.cmd([[
            if empty(glob('<cfile>:h')) || empty(glob('<cfile>'))
            Fe %:h/<cfile>
            else
            Fe <cfile>
            endif
        ]])
        end, 
        {silent=true}
        )
```

- [Optional] Create file and add this to ```nerdtree/nerdtree_plugin/yank_mapping.vim```

```vim
call NERDTreeAddKeyMap({
        \ 'key': '<leader>f',
        \ 'callback': 'NERDTreeYankCurrentNode',
        \ 'quickhelpText': 'put full path of current node and edit in floating window' })

function! NERDTreeYankCurrentNode()
    let n = g:NERDTreeFileNode.GetSelected()
    if n != {}
    execute ":Fe ". n.path.str()
    endif
    endfunction
```

## Learned:
- Lua
- Nvim api 
- Buffer and Window manipulation
- Floating windows are awesome




_Note:_

VimL version ![nvim-floatedit](https://github.com/metalelf0/nvim-floatedit) made before mine.
