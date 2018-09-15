
set global tabstop 4
set global indentwidth 4
set global aligntab false

set-option global BOM none
set-option global eolformat lf
set-option global ui_options ncurses_assistant=cat
set-option global autoreload yes
set-option global scrolloff 12,5

# Highlighters ─────────────────────────────────────────────────────────────────

add-highlighter global/show-whitespaces show-whitespaces -tab '›' -tabpad '⋅' -lf '↵' -spc ' ' -nbsp '⍽'

add-highlighter global/show-matching show-matching

# Highlight trailing spaces
add-highlighter global/trailing_white_spaces regex \h+$ 0:Error

