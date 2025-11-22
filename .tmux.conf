xdg-mime default kitty.desktop x-scheme-handler/terminal
export TERM=xterm-kitty
export TERMINAL=kitty
export ZSH="$HOME/.oh-my-zsh"
alias py='python3'
cpp() {
    g++ "$1" -o /tmp/tmp_cpp && /tmp/tmp_cpp && rm /tmp/tmp_cpp
}
mkcp() {
    filename="$1"
    if [ -z "$filename" ]; then
        echo "Usage: mkcpp <filename (without .cpp)>"
        return 1
    fi
    cat > "${filename}.cpp" <<EOF
#include <bits/stdc++.h>
using namespace std;
#define rep(i, a, b) for(int i = a; i < (b); ++i)
#define trav(a, x) for(auto& a : x)
#define all(x) x.begin(), x.end()
#define sz(x) (int)(x).size()
typedef long long ll;
typedef pair<ll, ll> pii;
typedef vector<ll> vi;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    
}
EOF
    echo "Created ${filename}.cpp"
}


alias cd=z

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
export FZF_ALT_C_COMMAND='find ~ -type d \( ! -path "*/\.*" -o -name ".*" \)'

# Created by `pipx` on 2025-03-17 23:40:25
export PATH="$PATH:/home/arturcs/.local/bin"

eval "$(zoxide init zsh)"
export PATH="/home/arturcs/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/arturcs/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select
