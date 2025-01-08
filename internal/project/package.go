package project

import (
	"encoding/json"
	"os"
)

type PackageJSON struct {
	Name            string            `json:"name,omitempty"`
	Version         string            `json:"version,omitempty"`
	Private         bool              `json:"private,omitempty"`
	Scripts         map[string]string `json:"scripts"`
	Dependencies    map[string]string `json:"dependencies,omitempty"`
	DevDependencies map[string]string `json:"devDependencies,omitempty"`
}

func UpdatePackageJSON() error {
	packagePath := "package.json"
	data, err := os.ReadFile(packagePath)
	if err != nil {
		return err
	}

	var pkg PackageJSON
	if err := json.Unmarshal(data, &pkg); err != nil {
		return err
	}

	// Add our custom scripts
	pkg.Scripts["sort-imports"] = "npx eslint --fix \"{app,lib,components,hooks,middleware,e2e,providers}/**/*.{ts,tsx,mdx}\""
	pkg.Scripts["prettier"] = "prettier --write \"{app,lib,components,hooks,middleware,e2e,providers}/**/*.{ts,tsx,mdx}\" --plugin prettier-plugin-tailwindcss --cache --end-of-line lf --use-tabs false --single-quote --arrow-parens avoid --tab-width 2"
	pkg.Scripts["clean"] = "concurrently \"pnpm sort-imports\" \"pnpm prettier\""

	updated, err := json.MarshalIndent(pkg, "", "  ")
	if err != nil {
		return err
	}

	return os.WriteFile(packagePath, updated, 0644)
}
