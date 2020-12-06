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

"" Fold config.
" Useful resource:
"  * https://unix.stackexchange.com/questions/141097/how-to-enable-and-use-code-folding-in-vim
"  * https://learnvimscriptthehardway.stevelosh.com/chapters/49.html
"  * https://www.linux.com/training-tutorials/vim-tips-folding-fun
" Useful bindings:
"  * zM -> Close all folds.
"  * zR -> Open all folds.
"  * zc -> Close fold under current cursor.
"  * zo -> Open fold under current cursor.
"  * zO -> Open all folds under current cursor.
"  * zj -> Move the cursor to the next fold.
"  * zk -> Move the cursor to the previous fold.
set foldmethod=syntax
" It makes sense to set the foldnestmax to 2 because of constructs like
" namespaces. In case foldnestmax would be 1 the entire namspace would be
" considered as a one giant fold. On the other side if foldnestmax is too high
" all small scopes would be created which is hard to navigate.
set foldnestmax=2
" Don't create folds by default. Create folds manually only if that is
" more convenient to use.
set nofoldenable

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
function! SetDarkColorScheme()
    set background=dark
    execute "!terminal_profile dark"
endfunction
function! SetLightColorScheme()
    set background=light
    execute "!terminal_profile light"
endfunction
command! SetDarkColorScheme call SetDarkColorScheme()
command! SetLightColorScheme call SetLightColorScheme()

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
\ 'passive_filetypes': ['cpp', 'javascript', 'typescript', 'clojure'] }
let g:syntastic_ignore_files = ['/usr/include/', '/usr/lib/']
let g:syntastic_python_checkers=['flake8']
let g:syntastic_hpp_checkers = ['cppcheck', 'clang_tidy', 'clang_check']
let g:syntastic_cpp_checkers = ['cppcheck', 'clang_tidy', 'clang_check']
let g:syntastic_cpp_check_header = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'run_local_eslint_check'
let g:syntastic_typescript_checkers = ['eslint']
let g:syntastic_typescript_eslint_exec = 'run_local_eslint_check'
let g:syntastic_clojure_checkers = ['eastwood']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_jump = 0
autocmd FileType c,cpp,javascript,typescript,clojure nnoremap <buffer><leader>sc :<C-u>SyntasticCheck<CR>

"" https://github.com/neoclide/coc.nvim
"let $NVIM_COC_LOG_LEVEL = 'debug'
":CocInfo :CocOpenLog
" https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
let g:coc_global_extensions = []

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
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
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

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

"" https://github.com/junegunn/fzf.vim
nnoremap <c-p> :GFiles<CR>

"" https://github.com/sirver/ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"" https://github.com/tpope/vim-fireplace
au Filetype clojure nmap <c-c><c-k> :Require<cr>

"" https://github.com/junegunn/rainbow_parentheses.vim
augroup rainbow_lisp
    autocmd!
    autocmd FileType lisp,clojure,scheme RainbowParentheses
    autocmd FileType text RainbowParentheses!
augroup END

"" https://github.com/venantius/vim-cljfmt
let g:clj_fmt_autosave = 0

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

"" YAML
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
