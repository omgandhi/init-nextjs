# Next.js Project Initializer

A Go CLI tool that automatically sets up Next.js projects with TypeScript, Tailwind CSS, shadcn/ui, and opinionated code formatting configurations.

## Installation

1. Clone the repository:
```bash
git clone https://github.com/omgandhi/init-nextjs
cd init-nextjs
```

2. Build the binary:
```bash
go build -o init-nextjs
```

3. Add to PATH:

Windows:
- Create a directory for binaries if you don't have one: `mkdir %USERPROFILE%\go-bins`
- Move the binary: `move init-nextjs.exe %USERPROFILE%\go-bins`
- Add to PATH: Search for "Environment Variables" in Windows settings → Edit Path → Add new entry with `%USERPROFILE%\go-bins`

macOS/Linux:
```bash
# Move to /opt/homebrew/bin/ (requires sudo)
# Use /usr/local/bin for Intel macs
sudo mv init-nextjs /opt/homebrew/bin/
```

## Usage

```bash
init-nextjs my-project-name
```

This command will:
1. Create a new Next.js project with TypeScript and Tailwind CSS
2. Set up shadcn/ui with default configuration
3. Install and configure ESLint with import sorting
4. Set up Prettier with tailwind class sorting
5. Create basic loading and not-found pages
6. Add convenience scripts for code formatting

### Project Structure

The initialized Next.js project will have the following structure:

```
my-project-name/
├── app/
│   ├── loading.tsx
│   ├── not-found.tsx
│   └── page.tsx
├── components/
│   └── ui/
├── eslint.config.mjs
├── package.json
├── tailwind.config.ts
└── tsconfig.json
```

### Available Scripts

After initialization, you can use these npm scripts:

```bash
pnpm sort-imports   # Sort imports using ESLint
pnpm prettier       # Format code with Prettier
pnpm clean          # Run both sort-imports and prettier
```

## Project Structure (Go)

```
init-nextjs/
├── cmd/
│   └── init-nextjs/
│       └── main.go
├── internal/
│   ├── project/
│   │   ├── package.go
│   │   └── setup.go
│   └── templates/
│       ├── components.go
│       └── configs.go
├── go.mod
└── README.md
```
