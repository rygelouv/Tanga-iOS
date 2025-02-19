#!/bin/sh

GIT_HOOKS=".git/hooks"
FLAG_FILE="$GIT_HOOKS/.hooks_installed"
SETUP_SCRIPT_PATH=~/Library/Developer/Xcode/UserScripts/setup-hooks.sh

# ✅ Step 1: Skip check in CI (GitHub Actions, Bitrise, etc.)
if [ -n "$CI" ]; then
    echo "⚠️ Skipping Git hook check in CI environment."
    exit 0
fi

echo "🔍 Checking if Git hooks are installed..."

# ✅ Step 2: Check if hooks are already installed
if [ -f "$FLAG_FILE" ]; then
    echo "✅ Git hooks are installed."
    exit 0
fi

# ❌ Step 3: Hooks are missing - Now check for setup script
echo "⚠️ Git hooks are missing!"

if [ ! -f "$SETUP_SCRIPT_PATH" ]; then
    echo "❌ ERROR: The setup script for Git hooks is also missing!"
    echo "⚠️ Please copy the setup script to the correct location by running:"
    echo ""
    echo "   cp scripts/setup-hooks.sh ~/Library/Developer/Xcode/UserScripts/"
    echo "   chmod +x ~/Library/Developer/Xcode/UserScripts/setup-hooks.sh"
    echo ""
    echo "📖 Refer to the README for more details."
    exit 1
fi

exit 0

