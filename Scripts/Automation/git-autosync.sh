#!/bin/bash

# This script automatically syncs a local git repository with its remote counterpart.
# Automatically syncs all repositories in the current directory, with option to run recursively.

# Check if git is installed
if ! command -v git &> /dev/null; then
	echo -e "\033[1;31git is not installed. Please install it first.\033[0m"
    echo -e "\033[1;31mYou can install it using: sudo apt install git\033[0m"
    exit 1
fi

# Function to sync a single repository
sync_repo()
{
    repo=$1
    
    # Check for possible errors in the repository path
    if [ -z "$repo" ]; then
        echo -e "\033[1;31mError: No repository path provided.\033[0m"
        return
    fi

    if [ ! -d "$repo" ]; then
        echo -e "\033[1;31mError: $repo is not a valid directory.\033[0m"
        return
    fi

    echo -e "\033[1;32mSyncing repository $repo\033[0m"

    # Sync the repository
    if ! git -C "$repo" fetch; then
        echo -e "\033[1;31mError: Failed to fetch repository $repo\033[0m"
        return
    fi

    if ! git -C "$repo" pull; then
        echo -e "\033[1;31mError: Failed to pull repository $repo\033[0m"
        return
    fi

    if ! git -C "$repo" push; then
        echo -e "\033[1;31mError: Failed to push repository $repo\033[0m"
        return
    fi
}

# Function to sync all repositories in a directory
sync_all_repos()
{
    for dir in */; do
        if [ -d "$dir/.git" ]; then
            sync_repo "$dir"
        fi
    done
}

# Function to sync all repositories in a directory recursively
sync_all_repos_recursive()
{
    find . -type d -name ".git" | while read -r gitdir; do
        repo="$(dirname "$gitdir")"
        sync_repo "$repo"
    done
}

# Function to show usage
help()
{
    echo "Usage: $0 [OPTION]"
    echo "Automatically sync all git repositories in the current directory."
    echo
    echo "Options:"
    echo "  -r, --recursive   Sync repositories recursively in all subdirectories"
    echo "  -h, --help        Show this help message and exit"
}

# Main function
main()
{
    # No arguments: sync all repos in current directory
    if [ $# -eq 0 ]; then
        sync_all_repos
        exit 0
    fi

    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -r|--recursive)
                sync_all_repos_recursive
                exit 0
                ;;
            -h|--help)
                help
                exit 0
                ;;
            *)
                echo -e "\033[1;31mUnknown option: $1\033[0m"
                help
                exit 1
                ;;
        esac
    done
}

# Call the main function
main "$@"