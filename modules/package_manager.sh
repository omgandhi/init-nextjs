#!/bin/bash

install_dependencies() {
    local project_name=$1
    local ui_library=$2

    cd "$project_name" || {
        log_error "Could not change directory to $project_name"
        exit 1
    }

    log_info "Installing common development dependencies..."
    if ! pnpm add -D "${COMMON_DEV_DEPENDENCIES[@]}"; then
        log_error "Failed to install common development dependencies"
        exit 1
    fi

    if [ "$ui_library" == "chakra" ]; then
        log_info "Installing Chakra UI dependencies..."
        if ! pnpm add "${CHAKRA_DEPENDENCIES[@]}"; then
            log_error "Failed to install Chakra UI dependencies"
            exit 1
        fi
    fi

    # Update package.json scripts
    local temp_file
    temp_file=$(mktemp)
    jq --argjson scripts "$PACKAGE_JSON_SCRIPTS" '.scripts += $scripts' package.json > "$temp_file" && mv "$temp_file" package.json

    log_success "Dependencies installed successfully"
}