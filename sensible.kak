
map global user <c-k> "! open https://github.com/mawww/kakoune#readme<ret>" -docstring "gh:kakoune#readme"
map global user <c-t> ": e -scratch<ret>! curl -L https://github.com/mawww/kakoune/raw/HEAD/contrib/TRAMPOLINE<ret>gk" -docstring tram
map global user K ": e %val{config}/kakrc<ret>" -docstring kakrc

map global user c ": comment-line<ret>" -docstring :comment-line
map global user C ": comment-block<ret>" -docstring :comment-block

# Highlighters ─────────────────────────────────────────────────────────────────

addhl global/ number-lines -relative -hlcursor
addhl global/ wrap

addhl global/ show-matching

# Highlight trailing spaces
addhl global/trailing-whitespaces regex "\h+$" 0:Error

