"""" General setup.

"" Leader definition.
:let mapleader = "-"

"" Pathogen setup.
" :scriptnames -> List all plugins.
let g:pathogen_disabled = ['']
execute pathogen#infect()

"" Profile vim.
function! StartProfile()
    execute ":profile start profile.vim"
    execute ":profile func *"
    execute ":profile file *"
endfunction
function! StopProfile()
    execute ":profile pause"
    execute ":noautocmd qall!"
endfunction

"" Bindings to edit and reload vimrc file.
nnoremap <leader>ce :vsplit $MYVIMRC<cr>
nnoremap <leader>cs :source $MYVIMRC<cr>

"" Windows (:help windows)
"      * https://stackoverflow.com/questions/6403716/shortcut-for-moving-between-vim-windows
"      * https://stackoverflow.com/questions/4556184/vim-move-window-left-right
"      * https://www.sourceallies.com/2009/11/vim-splits-an-introduction
" C-w + x -> Exchange current window with its neighbour.
" C-w + shift-H -> Move this window to the far left.
" C-w + shift-K -> Move this window to the top.
" C-w + S -> Horizontal split.
" C-w + v -> Vertical split.
" C-w + Q -> Close.
" :echo winnr() -> Print window number.
" Nwincmd w<CR> -> Go to Nth windows.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
noremap <C-y> :vertical resize +5<CR>
noremap <C-t> :vertical resize -5<CR>
noremap <C-h>u :resize +5<CR>
noremap <C-h>i :resize -5<CR>
" set preview window below
set splitbelow

let &colorcolumn="80"
highlight ColorColumn ctermbg=235 guibg=#2c2d27

"" You can also use g; and g, to move back- and forward in the list of your
" previous edit locations. C-o is previous location

"" Move line up or down.
nnoremap + ddkP
nnoremap - ddp

"" Register storage - copy everything that is selected under visual mode.
noremap <C-c> "+y

set laststatus=2
filetype off
filetype plugin indent on
syntax on
set relativenumber
set nocompatible
set backspace=2
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set noshowmode

"" Tabs navigation.
set guitablabel=%t
map <C-f> <Esc>:tabf
map <C-h> <Esc>:tabprev<CR>
map <C-l> <Esc>:tabnext<CR>
map <C-n> <Esc>:tabnew

"" Move the relative path to the current file into clipboard register.
nnoremap <C-g>bb :let @+ = expand("%").":".line(".")<CR>

"" How to paste over without overwriting register?
xnoremap p "_dP"

"" Commands mapped to the function keys.
function! ShowFKeysMappings()
    for i in range(1, 12) | execute 'map <F'.i.'>' | endfor
endfunction
" F1 -> Make program.
let g:buda_build_dir="build"
let &makeprg="(cd ".g:buda_build_dir." && make -j8)"
function! UpdateMakePrgBuildDir(path)
    let g:buda_build_dir=a:path
    let &makeprg="(cd ".g:buda_build_dir." && make -j8)"
endfunction
nmap <F1> :make<CR>

" F2 -> Uppercase the current word.
nnoremap <F2> bvwU<Esc>

" F3 -> Lowecase the current word.
nnoremap <F3> bvwu<Esc>

" F4 -> Call vim-autopep8.
autocmd FileType python noremap <buffer><F4> :call Autopep8()<CR>

" F5 -> Insert todo prefix.
function! Todo()
    execute ":normal! i TODO(buda): "
endfunction
nnoremap <F5> :call Todo()<CR>

" F6 -> Insert timestamp.
nnoremap <F6> "=strftime("\%Y/\%m/\%d-\%H:\%M:\%S")<CR>P

" F7 free.
" F8 free.

" F9 -> Add new line between parenthesis in insert mode.
inoremap <F9> <cr><ESC>O

" F10 ->  Skip the parenthesis (in insert mode) and start writing.
inoremap <F10> <ESC>%%a<space>

" F11 -> NOTE: Leave it free because of full screen.

" F12 -> Toggle Tagbar.
nnoremap <F12> :TagbarToggle<CR>

"" VIM session.
fu! SaveSession()
    execute 'mksession! ' . getcwd() . '/.session.vim'
endfunction
nnoremap <leader>ss :call SaveSession()<CR>

fu! RestoreSession()
if filereadable(getcwd() . '/.session.vim')
    execute 'so ' . getcwd() . '/.session.vim'
    if bufexists(1)
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
    endif
endif
endfunction
" Restore session on starting vim except if vimdiff is used
if !&diff
    autocmd VimEnter * nested call RestoreSession()
    if filereadable(getcwd() . '/.session.vim')
        autocmd VimEnter * NERDTree
    endif
endif


"""" Plugins setup.

"" https://github.com/altercation/vim-colors-solarized
set t_Co=256
let g:solarized_termcolors=256
let g:solarized_termtrans = 1
set background=dark
colorscheme solarized

"" https://github.com/scrooloose/syntastic
"let g:syntastic_debug = 3
":SyntasticCheck eslint
":mes
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" Set passive_filetypes because on the fly checking is slow.
let g:syntastic_mode_map = {
\ 'mode': 'active',
\ 'passive_filetypes': ['cpp', 'javascript', 'typescript'] }
let g:syntastic_ignore_files = ['/usr/include/', '/usr/lib/']
let g:syntastic_python_checkers=['flake8']
let g:syntastic_hpp_checkers = ['clang_check']
let g:syntastic_cpp_checkers = ['clang_check']
let g:syntastic_cpp_check_header = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'run_local_eslint_check'
let g:syntastic_typescript_checkers = ['eslint']
let g:syntastic_typescript_eslint_exec = 'run_local_eslint_check'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_jump = 0
autocmd FileType c,cpp,javascript,typescript nnoremap <buffer><leader>sc :<C-u>SyntasticCheck<CR>

"" https://github.com/neoclide/coc.nvim
"let $NVIM_COC_LOG_LEVEL = 'debug'
":CocInfo :CocOpenLog
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
let g:coc_global_extensions = []

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
autocmd!
" Setup formatexpr specified filetype(s).
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" Update signature help on jump placeholder
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold   :call CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"" https://github.com/bling/vim-airline
let g:airline_powerline_fonts = 1
let g:airline_theme='base16'
let g:airline#extensions#tabline#fnamemod = ':t'

"" https://github.com/vim-airline/vim-airline-themes

"" https://github.com/scrooloose/nerdtree.git
" i -> Open the selected file in a horizontal split window.
" s -> Open the selected file in a vertical split window.

"  https://github.com/jistr/vim-nerdtree-tabs (no actively maintained).
noremap <C-e> :NERDTreeTabsToggle<CR>

"" https://github.com/ctrlpvim/ctrlp.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_custom_ignore = 'node_modules\|\.git$\|build$\|lib$\|docs$\|libs$\'
let g:ctrlp_clear_cache_on_exit = 0
nnoremap <c-p>cc :CtrlPClearCache<CR>
nnoremap <c-p>pp :CtrlPBuffer<CR>
" Take a look at http://ctrlpvim.github.io/ctrlp.vim for other options.

"" https://github.com/ivalkeen/vim-ctrlp-tjump (tags jump)
if filereadable(expand(".tags"))
    set tags=.tags
    nnoremap <c-[> :CtrlPtjump<cr>
    vnoremap <c-[> :CtrlPtjumpVisual<cr>
else
    call add(g:pathogen_disabled, 'vim-ctrlp-tjump')
endif

"" https://github.com/tpope/vim-fugitive

"" https://github.com/airblade/vim-gitgutter

"" https://github.com/davidhalter/jedi-vim

"" https://github.com/nvie/vim-flake8

"" https://github.com/ton/vim-bufsurf
noremap [b :BufSurfBack<CR>
noremap [f :BufSurfForward<CR>

"" https://github.com/rhysd/vim-clang-format
autocmd FileType c,cpp nnoremap <buffer><leader>cf :<C-u>ClangFormat<CR>

"" https://github.com/tell-k/vim-autopep8
let g:autopep8_max_line_length=79
let g:autopep8_disable_show_diff=1
let g:autopep8_aggressive=2

"" https://github.com/majutsushi/tagbar

"" https://github.com/wesQ3/vim-windowswap

"" https://github.com/mileszs/ack.vim
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

"" https://github.com/alvan/vim-closetag

"" https://github.com/google/vim-codefmt.git
autocmd FileType html,css,sass,scss,less,json noremap <buffer><leader>cf :<C-u>FormatCode<cr>

"" https://github.com/google/vim-maktaba

"" https://github.com/Chiel92/vim-autoformat
let g:formatters_typescript = ['eslint_local']
let g:formatters_javascript = ['eslint_local']
autocmd FileType javascript,typescript noremap <buffer><leader>cf :<C-u>Autoformat<cr>

"" https://github.com/pangloss/vim-javascript

"" https://github.com/leafgarland/typescript-vim
let g:typescript_indent_disable=1

"" https://github.com/jason0x43/vim-js-indent.git
" Vim indentation of js/ts is an interesting topic. This problem solves a lot
" of problems.

"" https://github.com/Shougo/vimproc.vim

"" https://github.com/Quramy/tsuquyomi
" :TsuImport

"" https://github.com/ntpeters/vim-better-whitespace
highlight ExtraWhitespace ctermbg=darkred
autocmd FileType * EnableWhitespace
nnoremap <silent> <leader><space> :StripWhitespace<CR>

"" https://github.com/bfrg/vim-cpp-modern

"""" Workspace specific setup.

"" vim + tmux + gdb bindings and plugin setup.
" Send current line as a break point to the gdb session.
let g:gdb_active_tmux_session = ''
let g:gdb_active_tmux_pane = ''
autocmd FileType c,cpp nnoremap <buffer> <C-g>a
    \ :exe 'silent !tmux'
    \ 'send-keys -t ' . g:gdb_active_tmux_session . ':' . g:gdb_active_tmux_pane
    \ '"b %:' . line(".") '" enter'<CR> \| :redraw!<CR>
" terminal-debug settings.
let g:termdebug_wide = 163
:packadd! termdebug
" Run the embedded gdb by executing :Termdebug

"" Linmers and fixers.
noremap <leader>C :ccl <bar> lcl<CR>
noremap <leader>O :Errors<CR>
noremap <leader>ln :lnext<CR>
noremap <leader>lu :lprev<CR>

"" C/C++ development.
set nofoldenable
" Switch hpp <-> cpp.
nnoremap <C-g>h :e %<.hpp<CR>
nnoremap <C-g>i :e %<.cpp<CR>
nnoremap <C-g>l :e %<.lcp<CR>
" Open hpp or cpp in a vertical window.
nnoremap <C-g>vh :vsp %<.hpp<CR>
nnoremap <C-g>vi :vsp %<.cpp<CR>
nnoremap <C-g>vl :vsp %<.lcp<CR>
" Cscope.
if has('cscope')
    " Build and reload database file.
    function! ReloadCppCScope()
        " NOTE: Calling script available on the PATH.
        call system("rebuild_cpp_cscope")
        if v:shell_error == 1
            echo "rebuild_cpp_cscope script has failed!"
            return
        endif
        execute ":cs add cscope.out"
        echo "CScope reloaded"
    endfunction
    " Reload Cpp CScope.
    nnoremap <leader>fr :call ReloadCppCScope()<CR>
    " Find this C symbol.
    nnoremap <leader>fs :cs find s <cword><CR>
    " Find this definition.
    nnoremap <leader>fd :cs find g <cword><CR>
    " Find functions called by this function.
    nnoremap <leader>fe :cs find d <cword><CR>
    " Find functions calling this function.
    nnoremap <leader>fn :cs find c <cword><CR>
endif
" cppman (global documentation).
" Shift + K -> Open cppman in a tmux window.
" Ctrl + ] -> Go forward on keyword.
" Ctrl + T -> Go backward.
" q -> Quit the tmux window.
command! -nargs=+ Cppman silent! call system("cd /tmp && tmux split-window cppman " . expand(<q-args>))
autocmd FileType cpp nnoremap <silent><buffer><leader>K <Esc>:Cppman <cword><CR>
" NOTES:
" * cd /tmp is here because otherwise vim loads session file. It's a bit
"   hackish. Figure out a better way. Probably the cppman has to be changed.
"   One option is to change cppman/lib/pager.sh to run vim with -u NONE
"   (probably not the best option).
" * I had to change the iskeyword in the system level cppman lib folder
"   because it seems that < and > from the cppman config don't make sense
"   because almost everything from the pages have <,> (c++ likes templates a
"   lot) but the pages are not indexed with these two chars
" * master and apt package aren't in sync. I've edited the system level
"   vim config from master (removed `setl nonu` because that option doesn't work
"   with my tmux + vim config).
autocmd BufRead,BufNewFile *.c,*.cpp,*.hpp setlocal tabstop=2 shiftwidth=2 softtabstop=2

"" Frontend Development

"" Angular
" Switch between files in a component.
function! GetAngularComponentFileName()
    if expand('%:e:e') == 'spec.ts'
        return expand('%:r:r')
    else
        return expand('%:r')
    endif
endfunction
nnoremap <C-g>ht :exe 'e '.GetAngularComponentFileName().'.html'<CR>
nnoremap <C-g>sc :exe 'e '.GetAngularComponentFileName().'.scss'<CR>
nnoremap <C-g>sp :exe 'e '.GetAngularComponentFileName().'.spec.ts'<CR>
nnoremap <C-g>ts :exe 'e '.GetAngularComponentFileName().'.ts'<CR>

"" TypeScript
autocmd BufRead,BufNewFile *.ts,*.spec.ts setlocal tabstop=2 shiftwidth=2 softtabstop=2
