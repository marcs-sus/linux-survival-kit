#!/bin/bash

# This script automatically creates aliases and organizes them into ~/.<SHELL_NAME>_aliases
# Works with bash, zsh, ksh and similar shells
# Syntax: ./auto-aliases.sh <ALIAS_NAME> <COMMAND> [--shell <SHELL_NAME>]

set -e

# Detect shell if not specified, with priority
detect_shell() {
    # Check if --shell option was provided
    if [[ "$*" == *"--shell"* ]]; then
        local shell_arg
        shell_arg=$(echo "$@" | grep -oP '(?<=--shell\s)\w+' || true)
        if [ -n "$shell_arg" ]; then
            echo "$shell_arg"
            return
        fi
    fi

    # Detect shell from environment variable
    local shell_name
    shell_name=$(basename "$SHELL")
    case "$shell_name" in
        bash|zsh|ksh|ash|dash)
            echo "$shell_name"
            ;;
        *)
            echo "bash" 
        ;;
    esac
}

# Define shell-specific variables
SHELL_NAME=$(detect_shell "$@")
ALIAS_FILE="$HOME/.${SHELL_NAME}_aliases"
RC_FILE="$HOME/.${SHELL_NAME}rc"

ALIAS_NAME=$1
ALIAS_COMMAND=$2

# Snippet to be added to the RC file
FILE_SOURCE_SNIPPET=$(cat << 'EOF'
# Snippet automatically added by auto-aliases.sh
# Source ~/.SHELL_NAME_aliases if it exists
if [ -f ~/.SHELL_NAME_aliases ]; then
    . ~/.SHELL_NAME_aliases
fi
EOF
)
FILE_SOURCE_SNIPPET=${FILE_SOURCE_SNIPPET//SHELL_NAME/$SHELL_NAME}

# Base content for the alias file
BASE_ALIAS_FILE=$(cat << 'EOF'
# This file contains user-defined SHELL_NAME aliases.
# It is automatically sourced by ~/.SHELL_NAMErc.
EOF
)
BASE_ALIAS_FILE=${BASE_ALIAS_FILE//SHELL_NAME/$SHELL_NAME}

# Create ~/.$<SHELL_NAME>_aliases if it doesn't exist
if [ ! -f "$ALIAS_FILE" ]; then
    touch "$ALIAS_FILE"
    echo -e "\033[1;32mCreated $ALIAS_FILE.\033[0m"
fi

# Initialize ~/.<SHELL_NAME>_aliases with base content if empty
if [ ! -s "$ALIAS_FILE" ]; then
    echo -e "$BASE_ALIAS_FILE\n" >> "$ALIAS_FILE"
fi

# Ensure ~/.<SHELL_NAME>rc sources ~/.<SHELL_NAME>_aliases if not already present
if ! grep -q "\.${SHELL_NAME}_aliases" "$RC_FILE"; then
    echo -e "\n$FILE_SOURCE_SNIPPET\n" >> "$RC_FILE"
    echo -e "\033[1;32mUpdated $RC_FILE to source $ALIAS_FILE.\033[0m"
fi

# Check if parameters are provided
if [ -z "$ALIAS_NAME" ] || [ -z "$ALIAS_COMMAND" ] || [[ "$ALIAS_NAME" == "--shell" ]]; then
    echo -e "\033[1;31mUsage: $0 <ALIAS_NAME> <COMMAND>\033[0m"
    echo -e "\033[1;36mSupported shells: bash, zsh, ksh, and similar shells\033[0m"
    exit 1
fi

# Add the new alias to ~/.<SHELL_NAME>_aliases
echo "alias $ALIAS_NAME='$ALIAS_COMMAND'" >> "$ALIAS_FILE"

# Display success message
echo -e "\033[1;32mAlias '$ALIAS_NAME' for command '$ALIAS_COMMAND' added to $ALIAS_FILE.\033[0m"
