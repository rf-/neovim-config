(local {: g : o : bo : wo : env : opt : keymap} vim)
(local {:set map!} keymap)
(local {:nvim_command command :nvim_create_autocmd autocmd} vim.api)
(local str (require :std.string))
(local u (require :local.utils))
(local {: println} (require :nfnl.core))

(set g.mapleader " ")
(set g.maplocalleader " ")

; Use custom paths for Python if present
(let [python-2-path env.NEOVIM_PYTHON2_PATH
      python-3-path env.NEOVIM_PYTHON3_PATH]
  (if python-2-path
      (set g.python_host_prog python-2-path))
  (if python-3-path
      (set g.python3_host_prog python-3-path)))

; Basic settings
(set o.ambiwidth :single)
(set o.autoread true)
(set o.colorcolumn :80)
(set o.expandtab true)
(set o.hidden true)
(set o.mouse :a)
(set o.number true)
(set o.shiftwidth 2)
(set o.showmode false)
(set o.smarttab true)
(set o.softtabstop 2)
(set o.tabstop 8)
(set o.termguicolors true)

; Line wrapping: wrap at word boundaries, indent and mark next line
(set o.wrap true)
(set o.breakindent true)
(set o.linebreak true)
(set o.showbreak "\u{21B3} ")

; Choose theme depending on system dark mode
(let [system-style (str.trim (u.system "defaults read -g AppleInterfaceStyle"))]
  (set o.background (if (= system-style :Dark) :dark :light)))

; Display trailing whitespace
(set o.list true)
(set o.listchars "tab:  ,trail:·")

; Format options:
; * c: Autowrap comments using textwidth
; * r: Insert comment leader after hitting enter
; * o: Insert comment leader after hitting o or O
; * q: Allow formatting of comments with `gq`
; * j: Remove comment leader on join
(set o.formatoptions :croqj)

; Set default width, don't use two spaces after periods
(set o.textwidth 79)
(set o.joinspaces false)

; Keep the current split at a min width of 88 cols
(set o.winwidth 88)

; Open new splits below and to the right
(set o.splitbelow true)
(set o.splitright true)

; Keep some padding between the cursor and the edge of the screen
(set o.scrolloff 1)
(set o.sidescrolloff 5)

; History and persistent undo
(set o.history 1000)
(set o.undofile true)
(set o.undodir (vim.fn.expand "~/.config/nvim/undo"))
(set o.undolevels 2000)
(set o.undoreload 20000)

; Searching
(set o.hlsearch true)
(set o.incsearch true)
(set o.ignorecase true)
(set o.smartcase true)

; Directories for swp files
(set o.backupdir (vim.fn.expand "~/.config/nvim/backup//"))
(set o.directory (vim.fn.expand "~/.config/nvim/swap//"))

; Copy and paste to/from system clipboard
(set o.clipboard :unnamedplus)

; Don't show completion messages in status line
(opt.shortmess:append :c)

; Show matching brackets (but not for very long)
(set o.showmatch true)
(set o.matchtime 1)

; Use cool popup blending
(set o.pumblend 20)
(set o.winblend 10)

; Use popup menu for command-line completion
(set o.wildoptions :pum)

; Complete longest common string first, then open menu
(set o.wildmode "longest:full")

; Set up completion according to `nvim-cmp` recommendation
(set o.completeopt "menu,menuone,noselect")

; See instant feedback when entering commands
(set o.inccommand :nosplit)

; Merge sign column with line numbers
(set o.signcolumn :number)

; Increase terminal scrollback
(set g.terminal_scrollback_buffer_size 100000)

; Load project-specific config files
(set o.exrc true)

; Normalize the behavior of Y to match other capital letters
(map! [:n] :Y :y$)

; Allow holding shift while jumping to mark, which is easier for globals
(map! [:n] "~" "`")

; Remap Q to run macro in register q
(map! [:n :v] :Q "@q")

; Remap <M-k> in insert to produce digraphs (e.g., <M-k>'9 to produce ’)
(map! [:i] :<M-k> :<C-k>)

; Remap arrow keys to scroll by visible lines, not absolute lines
(map! [:n :v] :<Down> :gj)
(map! [:n :v] :<Up> :gk)
(map! [:i] :<Down> :<C-o>gj)
(map! [:i] :<Up> :<C-o>gk)

; Remap <C-d> and <C-u> to move the cursor instead of the window
(each [c-u-or-d j-or-k (pairs {:<C-d> :j :<C-u> :k})]
  (map! [:n] c-u-or-d (fn [] (command (.. "normal! " vim.wo.scroll j-or-k)))
        {:silent true}))

; Remap <C-{h,j,k,l}> to switch between splits
(each [_ key (pairs [:h :j :k :l])]
  (map! [:t :n :v :i] (.. :<C- key ">") (.. "<C-\\><C-n><C-w>" key)))

; Map <C-w><C-p> to close preview window, since <C-w><C-z> is very awkward
(map! [:n :v] :<C-w><C-p> ":pclose!<CR>")

; Map <Leader>3 or <Leader># to go to alternate file
(map! [:n :v] "<Leader>#" ":e#<CR>")
(map! [:n :v] :<Leader>3 ":e#<CR>")

; Map <Leader>e to quickly open a Ruby REPL
(map! [:n :v] :<Leader>e ":bel 10split term://pry<CR>")

; Map <Leader>h to clear the current search highlight
(map! [:n :v] :<Leader>h ":nohlsearch<CR>")

; Map <Leader>r to toggle relative line numbering
(map! [:n :v] :<Leader>r
      (fn [] (set wo.relativenumber (not wo.relativenumber))) {:silent true})

; Map <Leader>w to save
(map! [:n] :<Leader>w ":w<CR>")

; Map <Leader>q to close the current split (or quit)
(map! [:n :v] :<Leader>q ":q<CR>")

; Map <Leader>gd to show diagnostics
(map! [:n] :<Leader>gd (fn [] (vim.diagnostic.open_float)) {:silent true})

; Map F10 to show syntax groups under cursor
(map! [:n :v] :<F10> (fn [] (println (u.inspect-syntax-group))) {:silent true})

; Map <C-\><C-[> and <C-\><C-]> to switch tabs in all modes
(map! [:t :n :v :i] "<C-\\><C-[>" "<C-\\><C-n>gT")
(map! [:t :n :v :i] "<C-\\><C-]>" "<C-\\><C-n>gt")

; Map <C-\><C-t> to open a new terminal split
(map! [:t :n :v :i] "<C-\\><C-t>" "<C-\\><C-n>:split<CR><C-\\><C-n>:term<CR>")

; Map <C-\><C-p> to paste in terminal mode
(map! [:t] "<C-\\><C-p>" "<C-\\><C-n>p")

; Map <C-\><C-\> to exit terminal mode
(map! [:t] "<C-\\><C-\\>" "<C-\\><C-n>")

; Remap <M-k> to <C-k> in terminal to access "kill rest of line" bindings
(map! [:t] :<M-k> :<C-k>)

; Map <Enter> in terminal to also enter insert mode
; (We have to do this the ugly way because otherwise it breaks the Enter key in
; quickfix and I don't know why)
(command "nmap <expr> <CR> &buftype == 'terminal' ? \"i\\<CR>\" : \"\\<CR>\"")

; Return to previous location on open
(autocmd :BufReadPost {:pattern "*"
                       :callback (fn []
                                   (let [saved-line-nr (vim.fn.line "'\"")
                                         last-line-nr (vim.fn.line "$")]
                                     (if (and (> saved-line-nr 0)
                                              (<= saved-line-nr last-line-nr))
                                         (command "normal g'\"")))
                                   nil)})

; Make <C-d> and <C-u> scroll by 25% of window size instead of 50%
(autocmd [:BufReadPost :WinEnter]
         {:pattern "*"
          :callback (fn []
                      (set wo.scroll (math.floor (/ (vim.fn.winheight 0) 4)))
                      nil)})

; On entering a terminal buffer, automatically enter insert mode unless we're scrolled up
(autocmd [:TermOpen :BufWinEnter :WinEnter]
         {:pattern "term://*"
          :callback (fn []
                      (let [last-line-on-screen-nr (vim.fn.line :w$)
                            last-line-nr (vim.fn.line "$")]
                        (if (>= last-line-on-screen-nr last-line-nr)
                            (command :startinsert)))
                      nil)})

; Disable line numbers in terminals
(autocmd [:TermOpen :BufWinEnter]
         {:pattern "term://*" :command "setlocal nonumber"})

(autocmd [:BufWinLeave] {:pattern "term://*" :command "setlocal number"})

; Disable awful default mappings for SQL
(set g.omni_sql_no_default_maps true)

; Workaround for bad highlighting in SignColumn
; TODO: Figure out if this is still needed
(command "highlight clear SignColumn")

; Workaround for bad highlighting of Rust doc comments
; TODO: Figure out of this is still needed
(command "highlight link rustCommentLineDoc Comment")

; Workaround for unwanted "l" option (I think added by vim-ruby?)
; TODO: Figure out if this is still needed
(autocmd [:BufRead :BufNewFile]
         {:pattern "*" :command "setlocal formatoptions-=l"})

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
    (autocmd [:FileType] {:pattern filetype
                          :callback (fn []
                                      (each [setting value (pairs settings)]
                                        (tset bo setting value))
                                      nil)})))

; Include ? and ! in "words" in Ruby, so that tags work correctly with bang and
; question mark methods
(autocmd [:FileType] {:pattern :ruby :command "setlocal iskeyword+=!,?"})

; Enable wrapping for text files
(autocmd [:BufRead :BufNewFile]
         {:pattern :*.txt :command "setlocal wrap wrapmargin=2 textwidth=72"})

; Support weird Ruby filenames
(autocmd [:BufRead :BufNewFile]
         {:pattern "{Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}"
          :command "set filetype=ruby"})

; Add shortcuts for scoring word lists
(autocmd [:BufRead :BufNewFile] {:pattern :*.dict :command "set filetype=dict"})
(autocmd [:FileType] {:pattern :dict
                      :callback (fn []
                                  (each [idx score (ipairs [0 10 21 51 61])]
                                    (map! [:n] (tostring idx)
                                          (fn []
                                            (.. "0f;lciw" score "<Esc>:noh<CR>"))))
                                  nil)})

; Customize display of LSP diagnostics
(vim.diagnostic.config {:underline true
                        :virtual_text false
                        :signs true
                        :update_in_insert true
                        :severity_sort true})

(tset vim.lsp.handlers "textDocument/signatureHelp"
      (vim.lsp.with vim.lsp.handlers.signature_help
        {:silent true :focusable false}))

; Add shortcuts for jumping between diagnostics
(map! [:n] "[d" (fn [] (vim.diagnostic.goto_prev {:float false}))
      {:silent true})

(map! [:n] "]d" (fn [] (vim.diagnostic.goto_next {:float false}))
      {:silent true})
