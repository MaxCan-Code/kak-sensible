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
} plug "krobelus/kakoune-boost" %{
    map global user s ": surround-mode<ret>" -docstring surround
    map global user g ": enter-user-mode git<ret>" -docstring git
    unmap global git e ': git edit '
    unmap global git m ': enter-user-mode git-am<ret>'
    unmap global git p ': enter-user-mode git-push<ret>'
    unmap global git t ': enter-user-mode git-revert<ret>'
    unmap global git y ': enter-user-mode git-yank<ret>'
    unmap global git z ': enter-user-mode git-stash<ret>'
    unmap global git o ': enter-user-mode git-reset<ret>'
    unmap global git A ': enter-user-mode git-cherry-pick<ret>'
    unmap global git M ': enter-user-mode git-merge<ret>'
    unmap global git B ': enter-user-mode git-bisect<ret>'
    map global git-diff s ': git status -bs<ret>' -docstring status
    map global git-diff u ': git diff @{u}<ret>' -docstring 'view pre-push'
    map global git-apply a ': git add<ret>' -docstring add
    map global git s ': git status -bs<ret>' -docstring status
    map global git L ': git log --name-status --graph --oneline -WbX -C --decorate -n 20<ret>' -docstring log
    map global git v ": terminal git d origin<ret>" -docstring "vi(m)ew pre-push"
    declare-user-mode jj
    map global jj s ': jj status<ret>' -docstring status
    map global jj l ': jj log<ret>' -docstring log
    map global jj d ': jj diff --git<ret>' -docstring diff
    map global jj S ': jj show<ret>' -docstring show
    map global jj j ': jj ' -docstring jj
    map global user J ": enter-user-mode jj -lock<ret>" -docstring jj
} plug "alexherbo2/auto-pairs.kak" %{
    enable-auto-pairs
} plug "delapouite/kakoune-buffers" %{
    hook global WinDisplay .* info-buffers
    map global user b ": enter-user-mode buffers -lock<ret>" -docstring buffers
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
} plug "https://git.sr.ht/~hadronized/hop.kak" do %{
    cargo install hop-kak
  } config %{
    declare-option str hop_kak_keyset 'bnzxcmvtypqowieruahglskdfj'
    define-command -override hop-kak-words %{
      exec 'gtGbxs\w+<ret>:eval -no-hooks -- %sh{ hop-kak --keyset "$kak_opt_hop_kak_keyset" --sels "$kak_selections_desc" }<ret>'
    }
    map global user j :hop-kak-words<ret>
    map global user k :hop-kak-words<ret>
} plug "eraserhd/kak-ansi" do %{
    make
}
plug "niliaranet/yazi.kak" noload
plug "alexherbo2/dotfiles" noload
plug "Delapouite/kakoune-registers" noload
plug "astaugaard/reasymotion" noload
plug "evanrelf/byline.kak" noload
plug "caksoylar/kakoune-focus" noload

hook global WinSetOption filetype=nix %{
      set window lintcmd "statix check -s"
      set window formatcmd alejandra
      lint
}
hook global WinSetOption filetype=typst %{
      set window formatcmd typstyle
}

addhl global/ number-lines -full-relative -hlcursor
addhl global/ wrap
addhl global/ show-matching -previous
addhl global/ show-whitespaces -spc ' '
addhl global/trailing-whitespaces regex "\h+$" 0:Error
# plug "casonadams/insert-indicator" noload
hook global ModeChange .*:.*:insert %{
    set-face window PrimaryCursor      default,default,default+bur
    set-face window PrimaryCursorEol   default,default,default+bur
    set-face window SecondaryCursor    default,default,default+bur
    set-face window SecondaryCursorEol default,default,default+bur
    set-face window LineNumberCursor   default,default,default+bur
    set-face window PrimarySelection   default,default,default+bur
    set-face window SecondarySelection default,default,default+bur
}
hook global ModeChange .*:insert:.* %{
    unset-face window PrimaryCursor
    unset-face window PrimaryCursorEol
    unset-face window SecondaryCursor
    unset-face window SecondaryCursorEol
    unset-face window LineNumberCursor
    unset-face window PrimarySelection
    unset-face window SecondarySelection
}


map global normal O ": nop<ret>"
map global normal o :
map global normal <c-h> ": help " -docstring :help

declare-user-mode spell
map global spell e ": spell<ret>"
map global spell j ": spell-next<ret>"
map global spell k ": spell-prev<ret>"
map global spell <ret> ": spell-replace<ret>"

declare-user-mode misc
map global misc l ": colorscheme " -docstring :colorscheme
unset-face global MenuBackground

# map global misc <c-t> ": e -scratch<ret>! curl -L https://github.com/mawww/kakoune/raw/HEAD/contrib/TRAMPOLINE<ret>gk" -docstring tram
map global misc . ": cd ~/.dotfiles<ret>" -docstring .files
map global misc c ": cd ~/.config<ret>" -docstring config
map global misc i ": set -remove global autoinfo onkey<ret>" -docstring "autoinfo -onkey"
map global misc I ": set -add global autoinfo onkey<ret>" -docstring "autoinfo +onkey"
set -remove global autoinfo onkey
map global misc g ": grep<ret>" -docstring grep
map global misc j ": grep-next-match<ret>" -docstring grep-next-match
map global misc k ": grep-previous-match<ret>" -docstring grep-previous-match
map global misc K ": doc-key<ret>" -docstring doc-key

map global user a <a-a> -docstring selectors
map global user i <a-i> -docstring selectors
map global user l ": enter-user-mode -lock misc<ret>" -docstring misc
map global user m ": enter-user-mode -lock man<ret>" -docstring man
map global user e ": enter-user-mode -lock spell<ret>" -docstring spell
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
