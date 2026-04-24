#!/usr/bin/env bash
# update_path.sh
# Safely add common MSYS/Cygwin, Git Bash, Node and Python locations to PATH.
# Usage: source scripts/update_path.sh       # temporary for current shell
#    or:  source scripts/update_path.sh --persist   # add to ~/.bashrc

set -euo pipefail

# Helper: prepend a directory to PATH if it exists and isn't already in PATH
prepend_path() {
    dir="$1"
    [ -z "$dir" ] && return
    [ ! -d "$dir" ] && return
    case ":$PATH:" in
        *":$dir:"*) : ;; # already present
        *) PATH="$dir:$PATH" ;;
    esac
}

# 1) Add MSYS /usr/bin and common mingw bins (these provide sed, uname, cygpath, etc.)
prepend_path "/usr/bin"
prepend_path "/mingw64/bin"
prepend_path "/mingw32/bin"
prepend_path "/usr/local/bin"

# 2) Add common Node.js install locations (Windows style POSIX paths)
prepend_path "/c/Program Files/nodejs"
prepend_path "/c/Program Files (x86)/nodejs"
# Per-user npm global bin
if [ -n "${USERPROFILE:-}" ]; then
    # Convert Windows %USERPROFILE% to POSIX if it looks like C:\...; fallback to /c/Users/username
    up="$USERPROFILE"
    # replace backslashes with slashes and remove leading drive colon (C:) -> /c
    posix_up="${up//\\//}"
    # Try to normalize typical forms (this is tolerant - will still work if path doesn't exist)
    guess1="/c/${posix_up#?:}"
    prepend_path "$guess1/AppData/Roaming/npm"
fi

# 3) Add commonly installed python locations (Windows)
prepend_path "/c/Users/$USER/AppData/Local/Programs/Python/Python39"
prepend_path "/c/Users/$USER/AppData/Local/Programs/Python/Python310"
prepend_path "/c/Users/$USER/AppData/Local/Programs/Python/Python311"
prepend_path "/c/Users/$USER/AppData/Local/Programs/Python"
prepend_path "/c/Users/$USER/AppData/Local/Programs/Python/Launcher"

# 4) If py launcher exists, add its containing dir (common path)
prepend_path "/c/Users/$USER/AppData/Local/Programs/Python/Launcher"

# 5) Export updated PATH for current shell
export PATH

# Report what changed (best-effort)
printf "%s\n" "Updated PATH for current shell. First 12 entries:"
IFS=':' read -r -a parts <<< "$PATH"
for i in "${parts[@]:0:12}"; do printf ' - %s\n' "$i"; done

# 6) Persist if requested
if [ "${1:-}" = "--persist" ] || [ "${1:-}" = "-p" ]; then
    profile="$HOME/.bashrc"
    marker="# >>> added by update_path.sh >>>"
    # Append export only if marker not present
    if ! grep -qF "$marker" "$profile" 2>/dev/null; then
        cat >> "$profile" <<'EOF'

# >>> added by update_path.sh >>>
# Safe PATH additions for Git Bash / MSYS environment
if [ -d "/usr/bin" ]; then
    PATH="/usr/bin:$PATH"
fi
if [ -d "/mingw64/bin" ]; then
    PATH="/mingw64/bin:$PATH"
fi
if [ -d "/c/Program Files/nodejs" ]; then
    PATH="/c/Program Files/nodejs:$PATH"
fi
# Add per-user npm global if it exists
if [ -n "${USERPROFILE:-}" ]; then
    up="$USERPROFILE"
    posix_up="${up//\\//}"
    guess1="/c/${posix_up#?:}"
    if [ -d "$guess1/AppData/Roaming/npm" ]; then
        PATH="$guess1/AppData/Roaming/npm:$PATH"
    fi
fi
export PATH
# <<< added by update_path.sh <<<
EOF
        printf '%s
' "Wrote persistent PATH changes to $profile (restart your shell to apply)."
    else
        printf '%s
' "Persistent PATH marker already present in $profile; no changes made." 
    fi
fi

# End
