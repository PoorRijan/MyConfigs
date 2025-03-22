function fish_prompt
    # ============================================================================
    # FISH SHELL CUSTOM PROMPT
    # ============================================================================
    # This function defines a custom prompt for the fish shell that displays:
    # - Username and hostname
    # - Current directory
    # - Git repository status (when in a git repo)
    # - Python virtual environment (when active)
    # - Command execution time (for commands that take longer than threshold)
    # - Exit status of previous command (if it failed)
    # 
    # It uses a two-line format with decorative characters and colors.
    # ============================================================================

    # Save the status of the last command before we do anything else
    # $status is a special fish variable that contains the exit code of the last command
    set -l last_status $status

    # ===== COLOR DEFINITIONS =====
    # Define colors for different parts of the prompt
    # set_color is a fish function that outputs terminal color codes
    # You can use named colors or hex codes for custom colors
    set -l normal (set_color normal) # Reset to terminal's default color
    set -l white (set_color white)
    set -l turquoise (set_color 5fdfff) # Light blue color for structural elements
    set -l orange (set_color df5f00) # For hostname and duration
    set -l hotpink (set_color df005f) # For username and error codes
    set -l blue (set_color blue) # For the prompt character
    set -l limegreen (set_color 87ff00) # For the current directory
    set -l purple (set_color af5fff) # For virtual environment name

    # ===== GIT PROMPT CONFIGURATION =====
    # Configure how git information is displayed
    # These settings control the appearance of the git status in the prompt
    set -g __fish_git_prompt_char_stateseparator ' ' # Space between branch name and status flags
    set -g __fish_git_prompt_color 5fdfff # Color for git prompt text
    set -g __fish_git_prompt_color_flags df5f00 # Color for git status flags
    set -g __fish_git_prompt_color_prefix white # Color for opening characters
    set -g __fish_git_prompt_color_suffix white # Color for closing characters

    # Enable various git status indicators
    set -g __fish_git_prompt_showdirtystate true # Show * for dirty state, + for staged changes
    set -g __fish_git_prompt_showuntrackedfiles true # Show % for untracked files
    set -g __fish_git_prompt_showstashstate true # Show $ for stashed changes
    set -g __fish_git_prompt_show_informative_status true # Show detailed information

    # ===== FIRST LINE OF PROMPT =====
    # Start with a decorative character and username
    echo -n $turquoise'╭─'$hotpink$USER$white' at '$orange(prompt_hostname)$white' in '$limegreen(pwd|sed "s=$HOME=~=")$normal

    # ===== GIT STATUS =====
    # Add git status information if in a git repository
    # __fish_git_prompt is a built-in fish function that generates git status text
    echo -n (__fish_git_prompt)

    # ===== PYTHON VIRTUAL ENVIRONMENT =====
    # Show Python virtual environment name if one is activated
    # VIRTUAL_ENV is an environment variable set by virtual environment tools
    if set -q VIRTUAL_ENV
        echo -n $white' ('$purple(basename "$VIRTUAL_ENV")')'
    end

    # ===== COMMAND DURATION =====
    # Show execution time if the last command took more than 5 seconds
    # CMD_DURATION is a special fish variable that tracks command execution time in milliseconds
    if test $CMD_DURATION -gt 5000
        # Convert milliseconds to seconds for display
        set -l duration_sec (math "$CMD_DURATION / 1000")
        echo -n $white' took '$orange$duration_sec's'
    end

    # ===== COMMAND EXIT STATUS =====
    # Show exit status if the previous command failed (non-zero exit code)
    if test $last_status -ne 0
        echo -n $white' exited '$hotpink$last_status
    end

    # ===== SECOND LINE OF PROMPT =====
    # Start a new line for the command input
    echo
    # Add a decorative character and prompt symbol
    echo -n $turquoise'╰─'$blue'❯ '$normal
end

# ============================================================================
# CUSTOMIZATION GUIDE:
# ============================================================================
# 1. COLORS:
#    - Change the color variables at the top to match your preference
#    - Use `set_color --print-colors` in fish to see available named colors
#    - Or use hex codes: (set_color ff0000) for custom colors
#
# 2. SYMBOLS:
#    - Change '╭─'/'╰─' to other box-drawing characters or simple dashes
#    - Change '❯' to '>', '$', '➜', or any other prompt character
#
# 3. GIT PROMPT:
#    - Add/remove git indicators by changing the __fish_git_prompt_* settings
#    - See https://fishshell.com/docs/current/cmds/fish_git_prompt.html for options
#
# 4. COMMAND DURATION:
#    - Change 5000 to a different threshold in milliseconds
#    - Set higher for less frequent display, lower to see times for faster commands
#
# 5. ADDING NEW ELEMENTS:
#    - To add timestamp: echo -n $white' ['(date +%H:%M:%S)']'
#    - To add jobs count: if jobs -q; echo -n $white' jobs: '(jobs | wc -l); end
# ============================================================================
