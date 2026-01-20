# ~/.config/fish/config.fish
# =============================
# Clean Fish configuration for Hyprland
# =============================

# --- Disable default greeting ---
set -U fish_greeting

# --- Run fastfetch on interactive shells ---
if status is-interactive
    fastfetch
end

# --- Plugins ---
# Autosuggestions
if test -f ~/.local/share/fish/plugins/fish-autosuggestions/conf.d/fish-autosuggestions.fish
    source ~/.local/share/fish/plugins/fish-autosuggestions/conf.d/fish-autosuggestions.fish
end

# Syntax Highlighting
if test -f ~/.local/share/fish/plugins/fish-syntax-highlighting/share/functions/fish_highlight.fish
    source ~/.local/share/fish/plugins/fish-syntax-highlighting/share/functions/fish_highlight.fish
end

# =============================
# Beautiful Two‑Line Prompt
# =============================
function fish_prompt
    # Header line
    set_color cyan
    echo (whoami)"@"$hostname
    set_color brblack
    echo "-----------"
    set_color normal

    # Directory + Git
    set_color blue
    echo -n (prompt_pwd)
    set_color normal

    # Git branch (if inside repo)
    if type -q git
        set branch (git symbolic-ref --short HEAD ^/dev/null 2>/dev/null)
        if test -n "$branch"
            set_color magenta
            echo -n " ($branch)"
            set_color normal
        end
    end

    echo ""
    echo -n "> "
end
alias dots='/usr/bin/git --git-dir=/home/madara/.dotfiles --work-tree=/home/madara'
