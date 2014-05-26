c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

h() { cd ~/$1; }
_h() { _files -W ~/ -/; }
compdef _h h

# autocorrect is more annoying than helpful
unsetopt correct_all

# Some useful aliases
alias r='rails'
alias z='zeus'

# add plugin's bin directory to path
export PATH="$(dirname $0)/bin:$PATH"
