# NextJS Project Setup Scripts

A collection of bash scripts that automate the setup of a NextJS project with either Tailwind CSS or Chakra UI. These scripts provide a standardized project structure with pre-configured ESLint, Prettier, and TypeScript settings.

## Requirements

- Node.js >= 18.17.0 (Next.js 14 requirement)
- pnpm >= 8.0.0
- bash shell

## Package Versions

The scripts will install the following packages with their latest compatible versions:

### Development Dependencies
```json
{
  "prettier": "^3.0.0",
  "concurrently": "^8.0.0",
  "react-icons": "^4.0.0"
}
```

### Chakra UI Dependencies (if selected)
```json
{
  "@chakra-ui/react": "^2.8.0",
  "@emotion/react": "^11.0.0",
  "@emotion/styled": "^11.0.0",
  "framer-motion": "^10.0.0"
}
```

## Project Structure

```
your-project/
├── app/
│   ├── globals.css
│   ├── layout.tsx
│   ├── loading.tsx
│   ├── not-found.tsx
│   └── page.tsx
├── components/
│   ├── pages/
│   │   └── NotFound.tsx
│   └── utils/
│       └── Providers.tsx (Chakra UI only)
├── .eslintrc.json
├── .gitignore
├── package.json
└── tsconfig.json
```

## Usage

1. Clone this repository:
```bash
git clone https://github.com/omgandhi/init-nextjs.git
```

2. Make the scripts executable:
```bash
chmod +x scripts/**/*.sh
```

3. Run the setup script:
```bash
./scripts/init.sh
```

4. Follow the prompts:
    - Enter your project name (alphanumeric characters and hyphens only)
    - Select your preferred UI framework (Tailwind CSS or Chakra UI)

## Features

### ESLint Configuration
- Configured with Next.js recommended settings
- Import sorting rules
- Alphabetical import ordering
- Custom React import handling

### Prettier Configuration
- Single quotes
- 2-space indentation
- Arrow function parentheses handling
- End of line configuration

### TypeScript Setup
- Strict mode enabled
- Next.js types included
- Path aliases configured

### UI Framework Integration
- **Tailwind CSS**:
    - Configured with Next.js defaults
    - Custom utility classes
    - Responsive loading states

- **Chakra UI**:
    - Custom theme configuration
    - Provider setup
    - Responsive components
    - Custom loading animation

### Additional Features
- Development script shortcuts
- Import sorting automation
- File cleaning utilities
- Loading state components
- 404 page template
- Basic layout structure

## Scripts

The project includes several utility scripts in `package.json`:

```json
{
  "scripts": {
    "sort-imports": "Sorts imports across the project",
    "prettier": "Formats all project files",
    "clean": "Runs both sort-imports and prettier"
  }
}
```

## Error Handling

The scripts include robust error handling for:
- Invalid project names
- Missing dependencies
- Incompatible Node.js versions
- Failed installations
- Directory creation errors

## Known Limitations

1. The scripts currently only support Unix-like environments (Linux, macOS)
2. Windows users will need WSL or Git Bash
3. Node.js and pnpm must be pre-installed
