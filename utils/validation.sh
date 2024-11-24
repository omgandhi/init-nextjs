#!/bin/bash

check_environment() {
    # Check Node.js version (minimum v18.17.0 for Next.js 14)
    if ! command -v node >/dev/null; then
        log_error "Node.js is not installed"
        return 1
    fi

    node_version=$(node -v | cut -d 'v' -f 2)
    if ! verify_version "$node_version" "18.17.0"; then
        log_error "Node.js version must be >= 18.17.0 (current: $node_version)"
        return 1
    fi

    # Check pnpm
    if ! command -v pnpm >/dev/null; then
        log_error "pnpm is not installed. Install it with 'npm install -g pnpm'"
        return 1
    fi

    pnpm_version=$(pnpm -v)
    if ! verify_version "$pnpm_version" "8.0.0"; then
        log_error "pnpm version must be >= 8.0.0 (current: $pnpm_version)"
        return 1
    fi

    return 0
}

verify_version() {
    local current=$1
    local required=$2

    IFS='.' read -ra current_parts <<< "$current"
    IFS='.' read -ra required_parts <<< "$required"

    for ((i=0; i<${#required_parts[@]}; i++)); do
        if [ "${current_parts[i]:-0}" -lt "${required_parts[i]}" ]; then
            return 1
        elif [ "${current_parts[i]:-0}" -gt "${required_parts[i]}" ]; then
            return 0
        fi
    done

    return 0
}

validate_project_name() {
    local project_name=$1

    if [[ -z "$project_name" ]]; then
        log_error "Project name cannot be empty"
        return 1
    fi

    if [[ -d "$project_name" ]]; then
        log_error "Directory '$project_name' already exists"
        return 1
    fi

    if [[ ${#project_name} -gt 214 ]]; then
        log_error "Project name is too long (max 214 characters)"
        return 1
    fi

    return 0
}
