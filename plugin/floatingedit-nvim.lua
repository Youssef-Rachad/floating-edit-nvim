function split(pString, pPattern)
     -- https://stackoverflow.com/a/1579673
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

function Floaty(name_unsimplified)
    local name = vim.fn['simplify']("("..name_unsimplified..")")
    local lines   = vim.o.lines
    local columns = vim.o.columns
    local width   = math.min(unpack({columns - 4, math.max(unpack({80, columns - 20}))}))
    local height  = math.min(unpack({lines - 4,  math.max(unpack({20, lines - 10}))}))
    local left    = (columns - width) / 2
    local top     = (lines - height) / 2 - 1

    vim.g.opti = {
        ['relative']='editor',
        ['col']=left,
        ['row']=top,
        ['width']=width,
        ['height']=height,
        ['style']='minimal',
        ['focusable']=vim.v['false']
    }

    local string_top = "╭" .. string.rep("─", width - 2) .. "╮"
    local string_mid = "│" .. string.rep(" ", width - 2) .. "│"
    local string_bot = "╰-" .. name .. string.rep("─", width - string.len(name) - 3) .. "╯"

    lines = {}
    table.insert(lines, string_top)
    mid_array = split(string.rep(string_mid, height - 2, '@'), '@')
    table.foreach(mid_array, function(u, v) table.insert(lines, v) end)
    table.insert(lines, string_bot)

    border_bufnr = vim.api.nvim_create_buf(vim.v['false'], vim.v['true']) -- Returns the buffer index
    vim.api.nvim_buf_set_lines(border_bufnr, 0, -1, vim.v['true'], lines)
    borderwinid = vim.api.nvim_open_win(border_bufnr, true, vim.g.opti)

    -- lol imagine
    vim.g.opti = {
        ['relative']='editor',
        ['col']=left + 2,
        ['row']=top + 1,
        ['width']=width - 4,
        ['height']=height - 2,
        ['style']='minimal',
        ['focusable']=vim.v['true']
    }

    textbuf = vim.api.nvim_create_buf(vim.v['false'], vim.v['true'])
    vim.api.nvim_open_win(textbuf, vim.v['true'], vim.g.opti)
    vim.cmd([[ execute 'set winhl=Normal:Floating']])
    vim.api.nvim_create_autocmd('WinClosed', {
        pattern = "*",
        once = true,
        callback = function()
            vim.api.nvim_command('q | call nvim_win_close('..borderwinid..', v:true)')
        end
    })
    return textbuf
end

_G.FloatyEditing = function(query)
    Floaty(query)
    vim.api.nvim_command('edit '..query)
end
vim.cmd([[ command! -complete=file -nargs=? Fe call v:lua.FloatyEditing(<q-args>) ]])

