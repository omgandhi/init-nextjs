convert_to_pascal_case() {
    local input=$1
    local result=""
    local capitalize=1

    # Process one character at a time
    for (( i=0; i<${#input}; i++ )); do
        local char="${input:$i:1}"

        if [ "$char" = "-" ]; then
            capitalize=1
            continue
        fi

        if [ $capitalize -eq 1 ]; then
            result+=$(echo "$char" | tr '[:lower:]' '[:upper:]')
            capitalize=0
        else
            result+="$char"
        fi
    done

    echo "$result"
}

rename_ui_components() {
    local ui_dir="$COMPONENTS_DIR/ui"

    # Check if directory exists
    if [ ! -d "$ui_dir" ]; then
        return
    fi

    # Process all TypeScript/TSX files
    find "$ui_dir" -type f -name "*.ts*" | while read -r file; do
        local dir=$(dirname "$file")
        local base=$(basename "$file")
        local name_without_ext="${base%.*}"
        local ext="${base##*.}"

        # Convert the filename to PascalCase
        local pascal_name="$(convert_to_pascal_case "$name_without_ext").$ext"
        local new_path="$dir/$pascal_name"

        # Only rename if the file actually needs renaming
        if [ "$base" != "$pascal_name" ]; then
            mv "$file" "$new_path"
            log_info "Renamed: $base → $pascal_name"
        fi
    done
}