evaluate-commands %sh{
    plugins="$HOME/.local/share/kak/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
        git clone -q --filter blob:none \
            https://github.com/andreyorst/plug.kak \
            "$plugins/plug.kak"
    printf "%s\n" "source $plugins/plug.kak/rc/plug.kak"
}

plug-chain "andreyorst/plug.kak" noload config %{
    set global plug_install_dir %sh{ echo $HOME/.local/share/kak/plugins }
    set global plug_always_ensure true
} plug "chambln/kakoune-readline" config %{
    hook global WinCreate .* readline-enable
} plug "jordan-yee/kakoune-git-mode" config %{
    set global git_mode_use_structured_quick_commit true
    declare-git-mode
    map global user g ": enter-user-mode -lock git<ret>" -docstring git
    unmap global git I ': git-mode-init<ret>'
    unmap global git c ': git-mode-commit<ret>'
    unmap global git x ': git-mode-checkout<ret>'
    map global git s ': git status -bs<ret>' -docstring status
    map global git l ': git log --compact-summary --graph --oneline -WbX -C --decorate<ret>' -docstring log
    map global git f ': git commit --fixup=@<ret>' -docstring fixup
    map global git A ': git add -u<ret>' -docstring 'update pre-commit'
    map global git r ': terminal git restore -S %val{buffile}<ret>' -docstring unstage
    map global git B ": terminal git r " -docstring rebase
    map global git v ": terminal git d origin<ret>" -docstring "vi(m)ew pre-push"
    map global git S ': git diff --staged<ret>' -docstring 'view pre-commit'
    map global git O ': git diff origin<ret>' -docstring 'view pre-push'
} plug "delapouite/kakoune-text-objects" %{
    map global user o ": enter-user-mode selectors<ret>" -docstring selectors
} plug "alexherbo2/surround.kak" %{
    map global user s ": enter-user-mode surround<ret>" -docstring surround
} plug "alexherbo2/auto-pairs.kak" %{
    enable-auto-pairs
} plug "delapouite/kakoune-buffers" %{
    hook global WinDisplay .* info-buffers
    map global user b ": enter-user-mode -lock buffers<ret>" -docstring buffers
    map global buffers j ": buffer-next<ret>"
    map global buffers k ": buffer-previous<ret>"
    unmap global buffers a ga
    unmap global buffers b ": info-buffers<ret>"
    unmap global buffers c
    unmap global buffers f ": buffer "
    unmap global buffers n ": buffer-next<ret>"
    unmap global buffers p ": buffer-previous<ret>"
} plug "jordan-yee/kakoune-repl-mode" config %{
    require-module repl-mode
    map global user r ": enter-user-mode repl<ret>" -docstring "repl mode"
    repl-mode-register-default-mappings
} plug "tomKPZ/kakoune-easymotion" config %{
    map global user j :easy-motion-w<ret> -docstring easymotion
    map global user k :easy-motion-b<ret> -docstring easymotion
    face global EasyMotionForeground rgb:fdf6e3,rgb:268bd2+fg
}

nop plug "eraserhd/parinfer-rust" do %{
    cargo install -fq --path .
    mkdir -p ~/.local/bin
    ln -s ~/.cargo/bin/parinfer-rust ~/.local/bin
  } config %{
    hook global WinSetOption filetype=(clojure|lisp|scheme|racket) %{
        parinfer-enable-window -smart
    }
}

nop plug "https://git.sr.ht/~voroskoi/easymotion.kak"

hook global WinSetOption filetype=nix %{
      set window lintcmd "statix check -s"
      set window formatcmd nixfmt
      lint
}

addhl global/ number-lines -relative -hlcursor
addhl global/ wrap
addhl global/ show-matching -previous
addhl global/ show-whitespaces -spc ' '
addhl global/trailing-whitespaces regex "\h+$" 0:Error


map global normal O ": nop<ret>"
map global normal o :
map global normal <c-h> ": help " -docstring <help>

declare-user-mode misc
map global misc <c-l> ": colorscheme " -docstring :colorscheme
# map global misc l ": colorscheme kaleidoscope-light<ret>"
# map global misc d ": colorscheme gruvbox-dark<ret>"
# colorscheme desertex
# unset-face global MenuForeground

map global misc <c-t> ": e -scratch<ret>! curl -L https://github.com/mawww/kakoune/raw/HEAD/contrib/TRAMPOLINE<ret>gk" -docstring tram
# map global misc k ": cd %val{config}<ret>" -docstring kakrc
map global misc . ": cd ~/.dotfiles<ret>" -docstring .files
map global misc c ": cd ~/.config<ret>" -docstring config
map global misc i ": set -remove global autoinfo onkey<ret>" -docstring "autoinfo -onkey"
map global misc I ": set -add global autoinfo onkey<ret>" -docstring "autoinfo +onkey"
set -remove global autoinfo onkey

map global user l ": enter-user-mode misc<ret>" -docstring miscl
map global user m ": enter-user-mode -lock man<ret>" -docstring man
map global user u ": enter-user-mode " -docstring enter-user-mode
# https://github.com/Delapouite/kakoune-user-modes#tips
# alias global u enter-user-mode

map global user f :format<ret> -docstring :format
map global user c :comment-line<ret> -docstring :comment-line
map global user C :comment-block<ret> -docstring :comment-block
map global user w :w<ret> -docstring :w
map global user q :q<ret> -docstring :q
map global user z :wq<ret> -docstring :wq

map global view u <esc><c-u>V -docstring c-u
map global view d <esc><c-d>V -docstring c-d

map global man <ret> :man<ret> -docstring "man selection"

map global goto m c -docstring c
