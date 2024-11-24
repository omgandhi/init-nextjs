#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Source all utility functions and configurations
source "$SCRIPT_DIR/utils/logging.sh"
source "$SCRIPT_DIR/utils/validation.sh"
source "$SCRIPT_DIR/config/constants.sh"
source "$SCRIPT_DIR/modules/project_setup.sh"
source "$SCRIPT_DIR/modules/package_manager.sh"
source "$SCRIPT_DIR/modules/file_generation.sh"

main() {
    log_info "Starting NextJS project initialization..."

    # Validate environment
    check_environment || exit 1

    # Get project inputs
    read -r -p "Project name: " project_name

    # Create UI framework selection menu
    PS3="Select UI framework (enter number): "
    options=("Tailwind CSS" "Chakra UI")
    select opt in "${options[@]}"
    do
        case $opt in
            "Tailwind CSS")
                ui_library="tailwind"
                break
                ;;
            "Chakra UI")
                ui_library="chakra"
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done

    # Validate inputs
    validate_project_name "$project_name" || exit 1

    # Initialize project structure
    setup_project "$project_name"

    # Install dependencies
    install_dependencies "$project_name" "$ui_library"

    # Generate project files
    generate_project_files "$ui_library"

    log_success "Project setup completed successfully!"
}

main "$@"