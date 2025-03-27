package project

import (
	"fmt"
	"init-nextjs/internal/templates"
	"os"
	"os/exec"
)

func Setup(projectName string) error {
	if err := createNextApp(projectName); err != nil {
		return err
	}

	if err := os.Chdir(projectName); err != nil {
		return fmt.Errorf("failed to change directory: %w", err)
	}

	if err := setupShadcn(); err != nil {
		return fmt.Errorf("failed to setup shadcn: %w", err)
	}

	if err := installPackages(); err != nil {
		return fmt.Errorf("failed to install packages: %w", err)
	}

	if err := templates.CreateComponents("."); err != nil {
		return fmt.Errorf("failed to create components: %w", err)
	}

	if err := templates.CreateESLintConfig("."); err != nil {
		return fmt.Errorf("failed to create ESLint config: %w", err)
	}

	if err := templates.UpdateGitignore(); err != nil {
		return fmt.Errorf("failed to update gitignore: %w", err)
	}

	if err := UpdatePackageJSON(); err != nil {
		return fmt.Errorf("failed to update package.json: %w", err)
	}

	if err := codeCleanup(); err != nil {
		return fmt.Errorf("failed to run code cleanup: %w", err)
	}

	if err := gitCommit(); err != nil {
		return fmt.Errorf("failed to commit changes: %w", err)
	}

	return nil
}

func createNextApp(projectName string) error {
	cmd := exec.Command("npx", "create-next-app@latest", projectName,
		"--typescript", "--empty", "--use-pnpm", "--eslint",
		"--no-src-dir", "--app", "--tailwind", "--no-turbopack", "--yes")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to create Next.js project: %w", err)
	}
	return nil
}

func setupShadcn() error {
	cmd := exec.Command("pnpm", "dlx", "shadcn@latest", "init", "-d")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to initialize shadcn: %w", err)
	}
	return nil
}

func installPackages() error {
	cmd := exec.Command("pnpm", "install", "-D", "prettier", "concurrently", "prettier-plugin-tailwindcss", "@eslint/js")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to install packages: %w", err)
	}
	return nil
}

func codeCleanup() error {
	cmd := exec.Command("pnpm", "clean")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to run code cleanup: %w", err)
	}
	return nil
}

func gitCommit() error {
	addCmd := exec.Command("git", "add", ".")
	addCmd.Stdout = os.Stdout
	addCmd.Stderr = os.Stderr

	if err := addCmd.Run(); err != nil {
		return fmt.Errorf("failed to stage changes: %w", err)
	}

	commitCmd := exec.Command("git", "commit", "-m", "Project initialized")
	commitCmd.Stdout = os.Stdout
	commitCmd.Stderr = os.Stderr

	if err := commitCmd.Run(); err != nil {
		return fmt.Errorf("failed to commit changes: %w", err)
	}

	return nil
}
