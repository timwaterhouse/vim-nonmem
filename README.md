# vim-nonmem

Vim syntax and indent settings for NONMEM.

## Installation

Use your favourite plugin manager.  E.g., with `vim-plug` place this in your `.vimrc`:

```vim
Plug 'timwaterhouse/vim-nonmem'
```

… then run the following in Vim:

```vim
:source %
:PlugInstall
```

### Filetype

I've purposely avoided adding any kind of filetype detection, due to the myriad conventions for naming NONMEM files.  So you'll probably want to add something like the following in `$HOME/.vim/filetype.vim` (or elsewhere, see `:help new-filetype`) to appropriately set the filetype to `nonmem`:
```vim
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufNewFile,BufRead *.mod,*.lst setfiletype nonmem
augroup END
```
