#!/bin/sh

HOOKS_DIR=".githooks"
GIT_HOOKS=".git/hooks"
FLAG_FILE="$GIT_HOOKS/.hooks_installed"

echo "Checking Git hooks setup..."

# If hooks are already installed, exit
if [ -f "$FLAG_FILE" ]; then
    echo "✅ Git hooks already installed. Skipping setup."
    exit 0
fi

# Ensure hooks directory exists
if [ ! -d "$GIT_HOOKS" ]; then
    echo "⚠️ Git hooks directory not found! Make sure you have initialized a Git repository."
    exit 1
fi

# Symlink the pre-commit hook
ln -sf ../../$HOOKS_DIR/pre-commit $GIT_HOOKS/pre-commit

# Ensure it's executable
chmod +x $GIT_HOOKS/pre-commit

# Mark as installed
touch "$FLAG_FILE"

echo "✅ Git hooks successfully installed!"

