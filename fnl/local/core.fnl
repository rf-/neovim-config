(module local.core
  {autoload {nvim aniseed.nvim str std.string u local.utils}})

(import-macros {:opt-set set!
                :opt-get get!
                :opt-append set+!
                :def-keymap map!
                :def-keymap-fn map-fn!
                :def-autocmd autocmd!
                :def-autocmd-fn autocmd-fn!} :zest.macros)

(set nvim.g.mapleader " ")
(set nvim.g.maplocalleader " ")

; Use custom paths for Python if present
(let [python-2-path nvim.env.NEOVIM_PYTHON2_PATH
      python-3-path nvim.env.NEOVIM_PYTHON3_PATH]
  (if python-2-path
      (set nvim.g.python_host_prog python-2-path))
  (if python-3-path
      (set nvim.g.python3_host_prog python-3-path)))

; Basic settings
(set! :ambiwidth :single)
(set! :autoread true)
(set! :colorcolumn [80])
(set! :expandtab true)
(set! :hidden true)
(set! :mouse :a)
(set! :wrap false)
(set! :number true)
(set! :shiftwidth 2)
(set! :showmode false)
(set! :smarttab true)
(set! :softtabstop 2)
(set! :tabstop 8)
(set! :termguicolors true)
(set! :background :light)

; Choose theme depending on system dark mode
(let [system-style (str.trim (u.system "defaults read -g AppleInterfaceStyle"))]
  (set! :background (if (= system-style :Dark) :dark :light)))

; Display trailing whitespace
(set! :list true)
(set! :listchars "tab:  ,trail:·")

; Format options:
; * c: Autowrap comments using textwidth
; * r: Insert comment leader after hitting enter
; * o: Insert comment leader after hitting o or O
; * q: Allow formatting of comments with `gq`
; * j: Remove comment leader on join
(set! :formatoptions :croqj)

; Set default width, don't use two spaces after periods
(set! :textwidth 79)
(set! :joinspaces false)

; Keep the current split at a min width of 88 cols
(set! :winwidth 88)

; Open new splits below and to the right
(set! :splitbelow true)
(set! :splitright true)

; Keep some padding between the cursor and the edge of the screen
(set! :scrolloff 1)
(set! :sidescrolloff 5)

; History and persistent undo
(set! :history 1000)
(set! :undofile true)
(set! :undodir (nvim.fn.expand "~/.config/nvim/undo"))
(set! :undolevels 2000)
(set! :undoreload 20000)

; Searching
(set! :hlsearch true)
(set! :incsearch true)
(set! :ignorecase true)
(set! :smartcase true)

; Directories for swp files
(set! :backupdir (nvim.fn.expand "~/.config/nvim/backup"))
(set! :directory (nvim.fn.expand "~/.config/nvim/backup"))

; Copy and paste to/from system clipboard
(set! :clipboard :unnamedplus)

; Don't show completion messages in status line
(set+! :shortmess :c)

; Show matching brackets (but not for very long)
(set! :showmatch true)
(set! :matchtime 1)

; Use cool popup blending
(set! :pumblend 20)
(set! :winblend 10)

; Use popup menu for command-line completion
(set! :wildoptions [:pum])

; Complete longest common string first, then open menu
(set! :wildmode "longest:full")

; Set up completion according to `nvim-cmp` recommendation
(set! :completeopt [:menu :menuone :noselect])

; See instant feedback when entering commands
(set! :inccommand :nosplit)

; Merge sign column with line numbers
(set! :signcolumn :number)

; Increase terminal scrollback
(set nvim.g.terminal_scrollback_buffer_size 100000)

; Normalize the behavior of Y to match other capital letters
(map! :Y [n] :y$)

; Allow holding shift while jumping to mark, which is easier for globals
(map! "~" [n] "`")

; Remap Q to run macro in register q
(map! :Q [nv] "@q")

; Remap <M-k> in insert to produce digraphs (e.g., <M-k>'9 to produce ’)
(map! :<M-k> [i] :<C-k>)

; Remap arrow keys to scroll by visible lines, not absolute lines
(map! :<Down> [nv] :gj)
(map! :<Up> [nv] :gk)
(map! :<Down> [i] :<C-o>gj)
(map! :<Up> [i] :<C-o>gk)

; Remap <C-d> and <C-u> to move the cursor instead of the window
(each [c-u-or-d j-or-k (pairs {:<C-d> :j :<C-u> :k})]
  (map-fn! c-u-or-d [n :silent]
           (nvim.command (.. "normal " nvim.wo.scroll j-or-k))))

; Remap <C-{h,j,k,l}> to switch between splits
(each [_ key (pairs [:h :j :k :l])]
  (map! (.. :<C- key ">") [tnvi] (.. "<C-\\><C-n><C-w>" key)))

; Map <C-w><C-p> to close preview window, since <C-w><C-z> is very awkward
(map! :<C-w><C-p> [nv] ":pclose!<CR>")

; Map <Leader>3 or <Leader># to go to alternate file
(map! "<Leader>#" [nv] ":e#<CR>")
(map! :<Leader>3 [nv] ":e#<CR>")

; Map <Leader>e to quickly open a Ruby REPL
(map! :<Leader>e [nv] ":bel 10split term://pry<CR>")

; Map <Leader>h to clear the current search highlight
(map! :<Leader>h [nv] ":nohlsearch<CR>")

; Map <Leader>r to toggle relative line numbering
(map-fn! :<Leader>r [nv :silent]
         (set! :relativenumber (not nvim.wo.relativenumber)))

; Map <Leader>w to save
(map! :<Leader>w [n] ":w<CR>")

; Map <Leader>q to close the current split (or quit)
(map! :<Leader>q [nv] ":q<CR>")

; Map F10 to show syntax groups under cursor
(map-fn! :<F10> [nv :silent] (nvim.echo (u.inspect-syntax-group)))

; Map <C-\><C-[> and <C-\><C-]> to switch tabs in all modes
(map! "<C-\\><C-[>" [tnvi] "<C-\\><C-n>gT")
(map! "<C-\\><C-]>" [tnvi] "<C-\\><C-n>gt")

; Map <C-\><C-t> to open a new terminal split
(map! "<C-\\><C-t>" [tnvi] "<C-\\><C-n>:split<CR>:term<CR>")

; Map <C-\><C-p> to paste in terminal mode
(map! "<C-\\><C-p>" [t] "<C-\\><C-n>p")

; Map <C-\><C-\> to exit terminal mode
(map! "<C-\\><C-\\>" [t] "<C-\\><C-n>")

; Remap <M-k> to <C-k> in terminal to access "kill rest of line" bindings
(map! :<M-k> [t] :<C-k>)

; Map <Enter> in terminal to also enter insert mode
; (We have to do this the ugly way because otherwise it breaks the Enter key in
; quickfix and I don't know why)
(nvim.command "nmap <expr> <CR> &buftype == 'terminal' ? \"i\\<CR>\" : \"\\<CR>\"")

; Return to previous location on open
(autocmd-fn! [:BufReadPost] "*"
             (let [saved-line-nr (nvim.fn.line "'\"")
                   last-line-nr (nvim.fn.line "$")]
               (if (and (> saved-line-nr 0) (<= saved-line-nr last-line-nr))
                   (nvim.command "normal g'\""))))

; Make <C-d> and <C-u> scroll by 25% of window size instead of 50%
(autocmd-fn! [:BufReadPost :WinEnter] "*"
             (set! :scroll (math.floor (/ (nvim.fn.winheight 0) 4))))

; On entering a terminal buffer, automatically enter insert mode unless we're scrolled up
(autocmd-fn! [:TermOpen :BufWinEnter :WinEnter] "term://*"
             (let [last-line-on-screen-nr (nvim.fn.line :w$)
                   last-line-nr (nvim.fn.line "$")]
               (if (>= last-line-on-screen-nr last-line-nr)
                   (nvim.command :startinsert))))

; Disable line numbers in terminals
(autocmd! [:TermOpen :BufWinEnter] "term://*" "setlocal nonumber")
(autocmd! [:BufWinLeave] "term://*" "setlocal number")

; Disable awful default mappings for SQL
(set nvim.g.omni_sql_no_default_maps true)

; Workaround for bad highlighting in SignColumn
; TODO: Figure out if this is still needed
(nvim.command "highlight clear SignColumn")

; Workaround for bad highlighting of Rust doc comments
; TODO: Figure out of this is still needed
(nvim.command "highlight link rustCommentLineDoc Comment")

; Workaround for unwanted "l" option (I think added by vim-ruby?)
; TODO: Figure out if this is still needed
(autocmd! [:BufRead :BufNewFile] "*" "setlocal formatoptions-=l")

; Configure whitespace for various filetypes
(let [filetype-settings {:coffee {:shiftwidth 2 :softtabstop 2}
                         :css {:shiftwidth 2 :softtabstop 2}
                         :go {:expandtab false :tabstop 4 :shiftwidth 4}
                         :haxe {:tabstop 4 :shiftwidth 4 :softtabstop 4}
                         :javascript {:shiftwidth 2 :softtabstop 2}
                         :make {:expandtab false}
                         :python {:shiftwidth 4 :softtabstop 4 :textwidth 79}
                         :scala {:colorcolumn 100}
                         :scss {:shiftwidth 2 :softtabstop 2}
                         :typescript {:shiftwidth 2 :softtabstop 2}
                         :typescriptreact {:shiftwidth 2 :softtabstop 2}}]
  (each [filetype settings (pairs filetype-settings)]
    (autocmd-fn! [:FileType] filetype
                 (each [setting value (pairs settings)]
                   (tset nvim.lo setting value)))))

; Include ? and ! in "words" in Ruby, so that tags work correctly with bang and
; question mark methods
(autocmd! [:FileType] :ruby "setlocal iskeyword+=!,?")

; Enable wrapping for text files
(autocmd! [:BufRead :BufNewFile] :*.txt
          "setlocal wrap wrapmargin=2 textwidth=72")

; Support weird Ruby filenames
(autocmd! [:BufRead :BufNewFile]
          "{Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}"
          "set filetype=ruby")

; Add shortcuts for scoring word lists
(autocmd! [:BufRead :BufNewFile] :*.dict "set filetype=dict")
(autocmd-fn! [:FileType] :dict
             (each [idx score (ipairs [0 10 21 51 61])]
               (map! (tostring idx) [n] (.. "0f;lciw" score "<Esc>:noh<CR>"))))

; Customize display of LSP diagnostics
(vim.diagnostic.config {:underline true
                        :virtual_text false
                        :signs true
                        :update_in_insert true
                        :severity_sort true})

; Add shortcuts for jumping between diagnostics
(map-fn! "[d" [n :silent] (vim.diagnostic.goto_prev {:float false}))
(map-fn! "]d" [n :silent] (vim.diagnostic.goto_next {:float false}))

; Display signature popup when entering args
(autocmd-fn! [:CursorHoldI] "*" (vim.lsp.buf.signature_help))
