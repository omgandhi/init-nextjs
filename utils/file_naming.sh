#!/bin/bash

convert_to_pascal_case() {
    local filename=$1
    echo "$filename" | sed -E 's/(^|-)([a-z])/\U\2/g'
}

rename_ui_components() {
    local ui_dir="components/ui"

    # Check if directory exists
    if [ ! -d "$ui_dir" ]; then
        return
    }

    # Find all files in components/ui and rename them
    find "$ui_dir" -type f -name "*-*.ts*" | while read -r file; do
        local dir=$(dirname "$file")
        local base=$(basename "$file")
        local name_without_ext="${base%.*}"
        local ext="${base##*.}"

        # Convert the filename to PascalCase
        local pascal_name="$(convert_to_pascal_case "$name_without_ext").$ext"
        local new_path="$dir/$pascal_name"

        # Rename the file
        mv "$file" "$new_path"

        # Log the change
        log_info "Renamed: $base → $pascal_name"
    done
}