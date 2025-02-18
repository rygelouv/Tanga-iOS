#!/bin/sh

HOOKS_DIR=".githooks"
GIT_HOOKS=".git/hooks"
FLAG_FILE="$GIT_HOOKS/.hooks_installed"

echo "🔍 Checking if Git hooks are installed..."

# Check if hooks are already installed
if [ -f "$FLAG_FILE" ]; then
    echo "✅ Git hooks are already installed."
    exit 0
fi

# If not installed, prompt the developer
echo "⚠️ Git hooks are missing! Please run the following command, from project root directory to install them:"
echo ""
echo "   sh scripts/setup-hooks.sh"
echo ""
echo "⏳ This only needs to be done once per machine."
exit 1

