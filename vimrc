" This is everything that NeoBundle needs to work
""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundle package manager
NeoBundleFetch 'Shougo/neobundle.vim'

" Here you add plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'scrooloose/nerdtree' " file tree
NeoBundle 'jistr/vim-nerdtree-tabs' " one nerdtree for all buffers
NeoBundle 'tiagofumo/vim-nerdtree-syntax-highlight' " makes nerdtree looks good
NeoBundle 'ryanoasis/vim-devicons' " vim uses icons from patched font
NeoBundle 'ctrlpvim/ctrlp.vim' " fuzzy file open

" async process
NeoBundle 'Shougo/vimproc.vim', {
            \ 'build' : {
            \     'mac' : 'make -f make_mac.mak',
            \     'linux' : 'make',
            \    },
            \ }

NeoBundle 'Valloric/YouCompleteMe' " code completion engine
NeoBundle 'scrooloose/nerdcommenter' " coments
NeoBundle 'tpope/vim-fugitive' " git plugin
NeoBundle 'sheerun/vim-polyglot' " language pack

NeoBundle 'Valloric/MatchTagAlways' " tag matching for tag languages
NeoBundle 'ap/vim-css-color' " coloring #fff

NeoBundle 'Quramy/tsuquyomi' " advanced typescript things
NeoBundle 'Quramy/vim-js-pretty-template'
NeoBundle 'leafgarland/typescript-vim' " typescript indentation etc

NeoBundle 'bling/vim-airline' " bottom bar/buffer bar
NeoBundle 'rcabralc/monokai-airline.vim' " bottom bar coloring to monokai
NeoBundle 'duythinht/vim-coffee'


NeoBundle 'christoomey/vim-tmux-navigator' " navigation vim-tmux
NeoBundle 'benmills/vimux' " used by aginoodle fast test runner
NeoBundle 'othree/csscomplete.vim' "fuller CSS3 syntax for autocomplete
NeoBundle 'Raimondi/delimitMate' " auto closing tags and parenthesis
NeoBundle 'neomake/neomake' " async pylint checks
NeoBundle 'mattn/emmet-vim'
NeoBundle 'posva/vim-vue'

""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Starting back filetype
call neobundle#end()
filetype plugin indent on
filetype on

" End of NeoBundle setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Vim options starts here
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hidden " enhances how buffers work

" Indent options
set expandtab " tab now insert spaces
set tabstop=4 " amount of spaces is set to 4
set shiftwidth=4 " indent now takes 4 spaces
au FileType python setl sw=4 sts=4 et
au FileType vue setl sw=2 sts=2 et
au FileType typescript setl sw=2 sts=2 et
au FileType html setl sw=2 sts=2 et
au FileType javascript setl sw=2 sts=2 et

" Editor options
set number " enabled line numbers
syntax enable " syntax coloring
set t_Co=256
set background=dark
colorscheme sunburst
set cursorline " highlights current line
set colorcolumn=120 " coloring column
set mouse=a " enable mouse in all modes
set shiftround " uses multiple of shiftwidth when using >> or <<

" Search options
" when using lowercase matching lowercase and uppercase,
" when using uppercase matching only uppercase
set ignorecase
set smartcase
set hlsearch " highlight all search matches
set incsearch " incremental searching when typing

" No vim swaps
set nobackup
set noswapfile

" Split options
set splitbelow " open horizontal split below
set splitright " open vertical split on right side

" Switch off vim preview screen
set completeopt-=preview

" Uppercase commands
:command WQ wq
:command Wq wq
:command W w
:command Q q
:command QA qall
:command Qa qall
:command Xa xall
:command XA xall

" End of editor options
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Plugins options
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " show only file name in buffer bar

" MatchTagAlways
let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 1
highlight MatchTag ctermfg=black ctermbg=lightgreen guifg=black guibg=lightgreen

" Neomake settings
let g:one_lte_path =  '~/one-lte-backlog/'

function! PylintArgs()
    let l:filepath = expand('%:p')
    let l:relative_path = substitute(l:filepath, g:one_lte_path, '', '')
    return ['exec', 'backend', 'pylint', '--output-format=text', '--rcfile=pylint.cfg', '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} [{msg_id}]"', '--reports=n',  l:relative_path]
endfunction

autocmd FileType qf nnoremap <buffer> <Enter> <Enter>

call neomake#configure#automake('w')
let g:neomake_place_signs = 0
let g:neomake_python_enabled_makers = ['agipylint']
let g:neomake_enabled_makers = ['agipylint']
let g:neomake_python_agipylint_maker = {
        \ 'args': funcref('PylintArgs'),
        \ 'exe': 'docker-compose',
        \ 'errorformat':
            \ '%A%f:%l:%c:%t: %m,' .
            \ '%A%f:%l: %m,' .
            \ '%A%f:(%l): %m,' .
            \ '%-Z%p^%.%#,' .
            \ '%-G%.%#',
        \ 'output_stream': 'stdout',
        \ 'cwd': g:one_lte_path,
        \ 'append_file': '0',
        \ 'postprocess': [
        \   function('neomake#postprocess#GenericLengthPostprocess'),
        \   function('neomake#makers#ft#python#PylintEntryProcess'),
        \ ]}

let g:neomake_agipylint_maker = {
        \ 'args': ['exec', 'backend', 'pylint', '--output-format=text', '--rcfile=pylint.cfg', '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} [{msg_id}]"', '--reports=n',  g:one_lte_path . 'src/apps/'],
        \ 'exe': 'docker-compose',
        \ 'errorformat':
            \ '%A%f:%l:%c:%t: %m,' .
            \ '%A%f:%l: %m,' .
            \ '%A%f:(%l): %m,' .
            \ '%-Z%p^%.%#,' .
            \ '%-G%.%#',
        \ 'output_stream': 'stdout',
        \ 'cwd': g:one_lte_path,
        \ 'append_file': '0',
        \ 'postprocess': [
        \   function('neomake#postprocess#GenericLengthPostprocess'),
        \   function('neomake#makers#ft#python#PylintEntryProcess'),
        \ ]}

" TypeScript Tsuquyomi
let g:tsuquyomi_disable_quickfix = 1

" VUE
autocmd FileType vue syntax sync fromstart


" ctrlp
set wildignore+=*/eggs/*,*/backups/*,*/bin/*,*/bootstrap.py/*,*/build/*,*/buildout.cfg/*,*/develop-eggs/*,*/parts/*,*/logs/*,*/docs/*,*/src/backlog.egg-info/*,*/collected-statics/*,*/node_modules/*
let g:ctrlp_multiple_files = 'i' " Open multiple files in buffers ctrl z + ctrl o

" Ignore filetypes for ctrlp
let g:ctrlp_custom_ignore = {
            \ 'file': '\v\.(pyc)$',
            \ }

" YouCompleteMe triggers
let g:ycm_semantic_triggers = {}
let g:ycm_semantic_triggers['typescript'] = ['.']
let g:ycm_semantic_triggers['python'] = ['.']
let g:ycm_semantic_triggers['css'] = [ 're!^\s{2}', 're!:\s+' ]
let g:ycm_semantic_triggers['scss'] = [ 're!^\s{2}', 're!:\s+' ]

" NerdCommenter
let g:NERDDefaultAlign = 'left' " Align comment signs to left by default

" NerdTreeColors
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" python-mode - TODO does not work right now
"let g:pymode_python = 'python3'
"let g:pymode_lint=0
"let g:pymode_syntax=1
"let g:pymode_syntax_slow_sync=1
"let g:pymode_syntax_all=1
"let g:pymode_syntax_print_as_function=g:pymode_syntax_all
"let g:pymode_syntax_highlight_async_await=g:pymode_syntax_all
"let g:pymode_syntax_highlight_equal_operator=g:pymode_syntax_all
"let g:pymode_syntax_highlight_stars_operator=g:pymode_syntax_all
"let g:pymode_syntax_highlight_self=g:pymode_syntax_all
"let g:pymode_syntax_indent_errors=g:pymode_syntax_all
"let g:pymode_syntax_string_formatting=g:pymode_syntax_all
"let g:pymode_syntax_space_errors=g:pymode_syntax_all
"let g:pymode_syntax_string_format=g:pymode_syntax_all
"let g:pymode_syntax_string_templates=g:pymode_syntax_all
"let g:pymode_syntax_doctests=g:pymode_syntax_all
"let g:pymode_syntax_builtin_objs=g:pymode_syntax_all
"let g:pymode_syntax_builtin_types=g:pymode_syntax_all
"let g:pymode_syntax_highlight_exceptions=g:pymode_syntax_all
"let g:pymode_syntax_docstrings=g:pymode_syntax_all
"let g:pymode_options_max_line_length=120

"let g:pymode_rope=0
"let g:pymode_rope_completion=0
"let g:pymode_rope_complete_on_dot=0
"let g:pymode_rope_auto_project=0
"let g:pymode_rope_enable_autoimport=0
"let g:pymode_rope_autoimport_generate=0
"let g:pymode_rope_guess_project=0

"let g:pymode_folding=0
"let g:pymode_indent=1

"let g:pymode_run=1
"let g:pymode_run_bind='<F5>'

" End of plugin options
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Remaps
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""

"emmet
nmap <silent><leader>e :call emmet#expandAbbr(3, "")<CR>

" Git
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>ga :Gwrite<CR><CR>

" Camel case to underscore --> \c
nnoremap <leader>c :s#\(\<\u\l\+\\|\l\+\)\(\u\)#\l\1_\l\2#g<CR>

" Nerd tree startup --> \nt or \`
nnoremap <leader>nt :NERDTree<CR>
nnoremap ` :NERDTreeToggle<CR>

" Moving from split to split remap, with ctrl - hjkl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Synatastic shortcuts
nnoremap <leader>s :SyntasticCheck<CR>
nnoremap <leader>r :SyntasticReset<CR>

" Hiting enter switches off highlight
nnoremap <silent> <CR> :noh<CR>

" Buffers
nnoremap <leader>[ :bpre<CR>
nnoremap <leader>] :bnext<CR>
nnoremap <leader>q :bd<CR>
nnoremap <tab> :bnext<CR>

" NerdCommenter
" toggles comments --> #
nmap # <leader>c<Space>
vmap # <leader>c<Space>

" vimrc remaps
" \ev -> open vimrc
" \rv -> source vimrc
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>rv :so $MYVIMRC<CR>

" Tsquomi

nmap <leader>im :TsuImport<CR> :%s/"/'/g<CR>

" End of remap block
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Text replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Replaces pdb -> import pdb; pdb.set_trace()
abbreviate pdb import pdb; pdb.set_trace()

" Replaces lorem -> lorem text :-)
abbreviate lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

" End of text replace
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""


" On file save
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remove trailing whitspaces on file save
autocmd FileType c,cpp,cfg,java,htmldjango,html,php,ruby,python,javascript,typescript,json,vim autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" End of on file save
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Function which removes spaces
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" Fast aginoodle test runner
""""""""""""""""""""""""""""""""""""""""""""""""""""""
" usage:
" leader t - one test with current cursor position
" leader tt - one test with current cursor position, with clear database
" leader T - all tests in file
let g:Commands = {'one-lte-backlog': 'docker-compose exec backend pytest', 'aginoodle': '~/Aginoodle/aginoodle/bin/py.test', 'marta-pro': 'docker-compose exec backend pytest' }

function! RunTest(commands, reuse)
    let l:winview = winsaveview()
    execute '?def test'
    normal w

    let l:project = GetProjectName()

    if a:reuse
        let command = a:commands[l:project] . ' --reuse-db' . ' ' . expand('%') . ' -k ' . expand('<cword>')
    else
        let command = a:commands[l:project] . ' --create-db' . ' ' . expand('%') . ' -k ' . expand('<cword>')
    endif

    call winrestview(l:winview)
    execute 'nohlsearch'
    execute RunCommand(command)
    call winrestview(l:winview)
endfunction

function! RunTestFile(commands, reuse)
    let l:project = GetProjectName()

    if a:reuse
        execute RunCommand(a:commands[l:project] . ' --reuse-db' . ' ' . expand('%'))
    else
        execute RunCommand(a:commands[l:project] . ' --create-db' . ' ' . expand('%'))
    endif
endfunction

function! RunCommand(command)
    normal m'
    if exists(":VimuxRunCommand")
        execute VimuxRunCommand(a:command)
    else
        execute '!' . ' ' . a:command
    endif
endfunction

function! GetProjectName()
    let l:directory = execute('pwd')
    return split(l:directory, "/")[-1]
endfunction

map <leader>T :call RunTestFile(g:Commands, 1)<CR>
map <leader>TT :call RunTestFile(g:Commands, 0)<CR>
map <leader>t :call RunTest(g:Commands, 1)<CR>
map <leader>tt :call RunTest(g:Commands, 0)<CR>
" End of fast test runner
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" End of functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""
