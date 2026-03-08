
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/abhishekkakolla/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/abhishekkakolla/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/abhishekkakolla/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/abhishekkakolla/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
alias g='git status'
alias gp='git push'
alias gi='git add -i'
alias c='clear'
alias ig='python /Users/abhishekkakolla/code/ig/main.py'

fo() { open "$(fzf)"}

# Interactive fuzzy cd into a directory
fcd() { cd "$(find . -type d | fzf)" }

# Interactive file explorer with preview
ff() {
  while true; do
    local selected=$( (echo ".."; find . -maxdepth 1 -mindepth 1 ! -name '.*') | while read -r fullpath; do echo "$(basename "$fullpath")"$'\t'"$fullpath"; done | fzf --with-nth=1 --delimiter='\t' --preview='[[ -d {2} ]] && echo "📁 Directory: {2}" || head -n 50 {2}' --preview-window=right:60% --height=100% --border --layout=reverse --ansi --prompt="📁 $(pwd) > " --header-first --style=full)

    [[ -z "$selected" ]] && break

    if [[ -d "${selected#*$'\t'}" ]]; then
      cd "${selected#*$'\t'}"
    else
      open "${selected#*$'\t'}"
    fi
  done
}

export PATH="$HOME/.local/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/abhishekkakolla/.lmstudio/bin"
# End of LM Studio CLI section


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<



# Added by Antigravity
export PATH="/Users/abhishekkakolla/.antigravity/antigravity/bin:$PATH"

export CPPFLAGS="-I/opt/homebrew/opt/libomp/include $CPPFLAGS"
export LDFLAGS="-L/opt/homebrew/opt/libomp/lib $LDFLAGS"

