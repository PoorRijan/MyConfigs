# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Aliases
alias ide="jupyter lab --ip=$HOSTNAME --port 8888"

# Functions
function interim() {
    mv "$1" ~/interim_backup/
}

function gitup() {
    git add .
    git commit -a -m "$1"
    git push
}

# Environment Variables
export JULIA_NUM_THREADS=16
export PATH="$PATH:~/executables"

# Conda/Mamba Initialization
__conda_setup="$('/shares/baxter/users/rdhakal/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/shares/baxter/users/rdhakal/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/shares/baxter/users/rdhakal/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/shares/baxter/users/rdhakal/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/shares/baxter/users/rdhakal/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/shares/baxter/users/rdhakal/miniforge3/etc/profile.d/mamba.sh"
fi

# ============================================================================
# BASH SHELL CUSTOM PROMPT
# ============================================================================
# This script defines a custom prompt for the bash shell that displays:
# - Username and hostname
# - Current directory
# - Git repository status (when in a git repo)
# - Python virtual environment (when active)
# - Command execution time (for commands that take longer than threshold)
# - Exit status of previous command (if it failed)
#
# It uses a two-line format with decorative characters and colors.
# ============================================================================

# ===== COLOR DEFINITIONS =====
# Define colors for different parts of the prompt
# You can use ANSI escape codes for colors
normal=$(tput sgr0) # Reset to terminal's default color
white=$(tput setaf 7)
turquoise=$(tput setaf 81) # Light blue
orange=$(tput setaf 166)
hotpink=$(tput setaf 197)
blue=$(tput setaf 4)
limegreen=$(tput setaf 119)
purple=$(tput setaf 135)

# ===== GIT PROMPT CONFIGURATION =====
# Function to get git status
__git_ps1() {
  local git_status=$(git status 2>/dev/null)
  if [[ -n "$git_status" ]]; then
    local branch=$(git branch --show-current 2>/dev/null)
    local dirty=$(git diff --quiet 2>/dev/null; [[ $? -ne 0 ]] && echo '*')
    local staged=$(git diff --cached --quiet 2>/dev/null; [[ $? -ne 0 ]] && echo '+')
    local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | grep -q .; [[ $? -eq 0 ]] && echo '%')
    local stash=$(git stash list 2>/dev/null | grep -q .; [[ $? -eq 0 ]] && echo '$')

    if [[ -n "$branch" ]]; then
      echo -n "${white}(${turquoise}${branch}${white}${dirty}${staged}${untracked}${stash}${white})"
    fi
  fi
}

# ===== PYTHON VIRTUAL ENVIRONMENT =====
# Function to get virtual environment name
__venv_ps1() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo -n "${white} (${purple}$(basename "$VIRTUAL_ENV")${white})"
  fi
}

# ===== COMMAND DURATION =====
# Function to get command duration
__duration_ps1() {
  if [[ "$cmd_duration" -gt 5000 ]]; then
    local duration_sec=$((cmd_duration / 1000))
    echo -n "${white} took ${orange}${duration_sec}s"
  fi
}

# ===== COMMAND EXIT STATUS =====
# Function to get exit status
__exit_status_ps1() {
  if [[ "$last_status" -ne 0 ]]; then
    echo -n "${white} exited ${hotpink}${last_status}"
  fi
}

# ===== PROMPT FUNCTION =====
PROMPT_COMMAND='cmd_start=$(date +%s%3N)'

prompt_func() {
  local cmd_end=$(date +%s%3N)
  local cmd_duration=$((cmd_end - cmd_start))
  local last_status=$?

  # ===== FIRST LINE OF PROMPT =====
  printf "%s╭─%s%s%s at %s%s%s in %s%s%s" "${turquoise}" "${hotpink}" "${USER}" "${white}" "${orange}" "$(hostname)" "${white}" "${limegreen}" "${PWD//"$HOME"/~}" "${normal}"

  # ===== GIT STATUS =====
  __git_ps1

  # ===== PYTHON VIRTUAL ENVIRONMENT =====
  __venv_ps1

  # ===== COMMAND DURATION =====
  __duration_ps1

  # ===== COMMAND EXIT STATUS =====
  __exit_status_ps1

  # ===== SECOND LINE OF PROMPT =====
  printf "\n%s╰─%s❯ %s" "${turquoise}" "${blue}" "${normal}"
}

PS1='$(prompt_func)'

# ============================================================================
# CUSTOMIZATION GUIDE:
# ============================================================================
# 1. COLORS:
#   - Change the color variables at the top to match your preference
#   - Use `tput setaf <color_code>` to set colors. See `man tput`
#   - Color codes: 0-7 are standard, 8-255 are extended
#
# 2. SYMBOLS:
#   - Change '╭─'/'╰─' to other box-drawing characters or simple dashes
#   - Change '❯' to '>', '$', '➜', or any other prompt character
#
# 3. GIT PROMPT:
#   - Add/remove git indicators by modifying the __git_ps1 function
#
# 4. COMMAND DURATION:
#   - Change 5000 to a different threshold in milliseconds
#   - Set higher for less frequent display, lower to see times for faster commands
#
# 5. ADDING NEW ELEMENTS:
#   - To add timestamp: printf "%s [%s] " "${white}" "$(date +%H:%M:%S)"
#   - To add jobs count: if [[ $(jobs -p | wc -l) -gt 0 ]]; then printf "%s jobs: %s" "${white}" "$(jobs -p | wc -l)"; fi
# ============================================================================
