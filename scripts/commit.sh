#!/bin/bash
set -euo pipefail

# --- Check git status ---
# Detect pending merges, rebases, etc.
if [ -d ".git" ]; then
  if [ -f ".git/MERGE_HEAD" ] || [ -f ".git/REBASE_HEAD" ] || [ -f ".git/CHERRY_PICK_HEAD" ]; then
    echo "❌ Repository has an unfinished merge/rebase/cherry-pick. Please resolve it first."
    exit 1
  fi
else
  echo "❌ Not a git repository."
  exit 1
fi

# Detect staged or unstaged changes
if [ -z "$(git status --porcelain)" ]; then
  echo "❌ Nothing to commit. Working tree clean."
  exit 1
fi

# Check for staged changes
if [ -z "$(git diff --cached --name-only)" ]; then
  echo "❌ No staged changes to commit. Please stage your changes first."
  exit 1
fi

# Run checks on the code (if fails, run 'npm run fix')
npm run validate || {
  echo "❌ Lint or format check failed. Please fix issues first (try 'npm run fix')."
  exit 1
}

# --- Ask for commit type (mandatory) ---
echo "Select commit type:"
echo "1) Fix"
echo "2) Chore"
echo "3) Feat"

while true; do
  read -p "Enter option number (1-3): " type_choice
  case "$type_choice" in
    1) commit_type="Fix"; break ;;
    2) commit_type="Chore"; break ;;
    3) commit_type="Feat"; break ;;
    *) echo "❌ Invalid choice. Please enter 1, 2, or 3." ;;
  esac
done

# --- Ask for ticket number (optional) ---
read -p "Ticket number (optional): " ticket

# --- Commit title (mandatory) ---
while true; do
  read -p "Commit title (mandatory): " title
  if [ -n "$title" ]; then
    break
  fi
  echo "❌ Commit title cannot be empty. Please enter a title."
done

# --- Commit message ---
temp_file_msg=$(mktemp)
echo "# Write your commit message below" > "$temp_file_msg"
${EDITOR:-vi} "$temp_file_msg"
message=$(grep -v '^#' "$temp_file_msg" | sed '/^\s*$/d')
rm "$temp_file_msg"

if [ -z "$message" ]; then
  echo "❌ Commit message cannot be empty"
  exit 1
fi

# --- BREAKING CHANGES message (optional) ---
read -p "# Describe any BREAKING CHANGES (optional): " breaking

# Compose commit type with optional ticket
if [ -n "$ticket" ]; then
  type_with_ticket="$commit_type($ticket)"
else
  type_with_ticket="$commit_type"
fi

# Compose final commit message
commit_msg="$type_with_ticket: $title"

if [ -n "$message" ]; then
  commit_msg="$commit_msg

$message"
fi
if [ -n "$breaking" ]; then
  commit_msg="$commit_msg

BREAKING CHANGE: $breaking"
fi

git commit -m "$commit_msg"

echo "..."
echo "✅ Commit created."
