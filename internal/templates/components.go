package templates

import (
	"os"
	"path/filepath"
)

const NotFoundComponent = `export default function NotFound() {
  return (
    <div className="flex h-[50vh] w-full flex-col items-center justify-center gap-2">
      <h2 className="text-xl font-bold">Not Found</h2>
      <p>Could not find the requested resource</p>
    </div>
  );
}`

const LoadingComponent = `export default function Loading() {
  return (
    <div className="flex h-[50vh] w-full items-center justify-center">
      <div className="h-8 w-8 animate-spin rounded-full border-b-2 border-gray-900" />
    </div>
  );
}`

func CreateComponents(projectPath string) error {
	appDir := filepath.Join(projectPath, "app")

	// Create not-found.tsx
	if err := os.WriteFile(filepath.Join(appDir, "not-found.tsx"), []byte(NotFoundComponent), 0644); err != nil {
		return err
	}

	// Create loading.tsx
	return os.WriteFile(filepath.Join(appDir, "loading.tsx"), []byte(LoadingComponent), 0644)
}
