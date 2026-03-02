#!/bin/bash
# PostToolUse hook — TypeScript type check after Edit/Write operations
# Runs tsc --noEmit on edited .ts/.tsx files to catch type errors immediately

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
    echo '{}'
    exit 0
fi

case "$FILE_PATH" in
    *.ts|*.tsx)
        # Determine which tsconfig to use based on file path
        PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
        if [[ "$FILE_PATH" == *"/apps/api/"* ]]; then
            TSCONFIG="$PROJECT_DIR/apps/api/tsconfig.json"
        elif [[ "$FILE_PATH" == *"/apps/web/"* ]]; then
            TSCONFIG="$PROJECT_DIR/apps/web/tsconfig.json"
        elif [[ "$FILE_PATH" == *"/packages/shared/"* ]]; then
            TSCONFIG="$PROJECT_DIR/packages/shared/tsconfig.json"
        else
            echo '{}'
            exit 0
        fi

        if [ ! -f "$TSCONFIG" ]; then
            echo '{}'
            exit 0
        fi

        # Run tsc on just this file, capture first 5 errors
        ERRORS=$(cd "$PROJECT_DIR" && npx tsc --noEmit -p "$TSCONFIG" 2>&1 | grep -A 1 "$(basename "$FILE_PATH")" | head -10)
        if [ -n "$ERRORS" ] && echo "$ERRORS" | grep -q "error TS"; then
            # Escape for JSON
            ESCAPED=$(echo "$ERRORS" | head -5 | sed 's/"/\\"/g' | tr '\n' ' ')
            echo "{\"decision\":\"allow\",\"reason\":\"TypeScript error detected after edit: $ESCAPED\"}"
        else
            echo '{}'
        fi
        exit 0
        ;;
esac

echo '{}'
exit 0
