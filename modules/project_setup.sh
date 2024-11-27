#!/bin/bash

setup_project() {
    local project_name=$1

    log_info "Creating Next.js project: $project_name"

    create_next_app_command="npx create-next-app@latest \"$project_name\" --typescript --empty --use-pnpm --eslint --no-src-dir --app --tailwind"

    if ! eval "$create_next_app_command"; then
        log_error "Failed to create Next.js project"
        exit 1
    fi

    # Create necessary directories
    mkdir -p "$project_name/$COMPONENTS_DIR"
    mkdir -p "$project_name/$COMPONENTS_PAGES_DIR"
    mkdir -p "$project_name/$COMPONENTS_UTILS_DIR"

    log_success "Project structure created successfully"
}