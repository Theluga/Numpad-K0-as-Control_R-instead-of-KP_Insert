# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export TERM="xterm-256color"

bindkey "^[[3~" delete-char
#bindkey '^[[2~' overwrite-mode 
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line

# Function to set the cursor to a block shape (blinking)
set_block_cursor() {
    printf '\e[1 q'  # Set cursor to block shape
}

# Function to set the cursor to a line shape (blinking)
set_line_cursor() {
    printf '\e[3 q'  # Set cursor to line shape
}

# Function to toggle between insert and overtype modes
toggle_overtype_mode() {
     if [[ $ZLE_STATE == *"overwrite"* ]]; then
        # Switch to isert mode
        set_block_cursor
        zle overwrite-mode
    else
        # Switch to insert mode
        set_line_cursor
        zle overwrite-mode
    fi
}

handle_enter() {
    # Call the default ZLE function to accept the line
    zle accept-line    
    set_block_cursor
}

# Create a zle widget for the toggle function
zle -N toggle_overtype_mode
zle -N handle_enter

# Bind the Insert key to toggle overtype mode
bindkey '^[[2~' toggle_overtype_mode
bindkey '^M' handle_enter




#error command not found handler
source "${XDG_CACHE_HOME:-$HOME/.local}/share/command_not_found.zsh"

## Options section
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt correct                                                  # Auto correct mistakes
setopt nobeep                                                   # No beep
setopt histignorespace                                          # Don't save commands that start with space
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#syntax
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=213'
ZSH_HIGHLIGHT_STYLES[comment]='fg=213,bold'

#history-search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word 

#auto suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

#completions
fpath=(/usr/share/zsh/site-functions $fpath)

zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
zstyle ':completion:*' menu select                              # Highlight menu selection
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

autoload -Uz compinit && compinit
POWERLEVEL9K_DISABLE_GITSTATUS=true
