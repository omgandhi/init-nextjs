package templates

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
)

const ESLintConfig = `import path from "node:path";
import { fileURLToPath } from "node:url";

import { FlatCompat } from "@eslint/eslintrc";
import js from "@eslint/js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

export default [...compat.extends("next/core-web-vitals"), {
    rules: {
        "import/order": ["warn", {
            groups: ["builtin", "external", "internal", "parent", "sibling", "index"],

            pathGroups: [{
                pattern: "react",
                group: "external",
                position: "before",
            }],

            pathGroupsExcludedImportTypes: ["react"],
            "newlines-between": "always",

            alphabetize: {
                order: "asc",
                caseInsensitive: true,
            },
        }],
    },
}];`

func CreateESLintConfig(projectPath string) error {
	return os.WriteFile(filepath.Join(projectPath, "eslint.config.mjs"), []byte(ESLintConfig), 0644)
}

func UpdateTailwindConfig(projectPath string) error {
	configPath := filepath.Join(projectPath, "tailwind.config.ts")
	content, err := os.ReadFile(configPath)
	if err != nil {
		return err
	}

	contentPattern := regexp.MustCompile(`content:\s*\[([^\]]*)\]`)
	newContent := `content: ["./app/**/*.{js,ts,jsx,tsx,mdx}", "./lib/**/*.{js,ts,jsx,tsx,mdx}", "./components/**/*.{js,ts,jsx,tsx,mdx}"]`

	updatedConfig := contentPattern.ReplaceAllString(string(content), newContent)

	return os.WriteFile(configPath, []byte(updatedConfig), 0644)
}

func UpdateGitignore() error {
	f, err := os.OpenFile(".gitignore", os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		return fmt.Errorf("failed to open .gitignore: %w", err)
	}
	defer f.Close()

	if _, err := f.WriteString("\n.idea\n"); err != nil {
		return fmt.Errorf("failed to write entry: %w", err)
	}

	return nil
}
