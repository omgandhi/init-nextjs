#!/bin/bash

generate_project_files() {
    local ui_library=$1

    log_info "Generating project files..."

    # Generate ESLint config
    echo "$ESLINT_CONFIG" > .eslintrc.json

    # Generate other files based on UI library choice
    if [ "$ui_library" == "chakra" ]; then
        generate_chakra_files
    else
        generate_tailwind_files
    fi

    # Generate common files
    generate_common_files

    # Clean up public directory
    rm -rf public/*

    # Add .idea to .gitignore
    echo ".idea" >> .gitignore

    # Run cleanup scripts
    if ! eval "pnpm clean"; then
        log_warning "Failed to run cleanup scripts"
    fi

    log_success "Project files generated successfully"
}

generate_chakra_files() {
    # Create Providers.tsx
    cat > "$COMPONENTS_UTILS_DIR/Providers.tsx" << 'EOT'
import { ReactNode, Suspense } from 'react';

import { ChakraProvider, createSystem, defaultConfig } from '@chakra-ui/react';

import Loading from '@/app/loading';

export const system = createSystem(defaultConfig, {
  theme: {
    tokens: {
      fontWeights: {
        normal: { value: 400 },
        medium: { value: 500 },
        bold: { value: 700 },
      },
    },
  },
});

interface ProvidersProps {
  children: ReactNode;
}

function ProvidersContent({ children }: ProvidersProps) {
  return <ChakraProvider value={system}>{children}</ChakraProvider>;
}

export function Providers({ children }: ProvidersProps) {
  return (
    <Suspense fallback={<Loading />}>
      <ProvidersContent>{children}</ProvidersContent>
    </Suspense>
  );
}
EOT

    # Create layout.tsx for Chakra
    cat > "$APP_DIR/layout.tsx" << 'EOT'
import type { Metadata } from "next";
import { ReactNode } from "react";
import { Inter } from "next/font/google";
import { Providers } from '@/components/utils/Providers';
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "My Project",
  description: "A project built by Om Gandhi",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  );
}
EOT

    # Create loading.tsx for Chakra
    cat > "$APP_DIR/loading.tsx" << 'EOT'
'use client';

import { chakra, Center } from '@chakra-ui/react';
import { keyframes } from '@emotion/react';

const pulse = keyframes`
    0% { stroke-dashoffset: 0; }
    100% { stroke-dashoffset: -260; }
`;

export default function Loading() {
  return (
    <chakra.div w="100%" h="100vh">
      <Center flexDir="column" h="100%">
        <chakra.svg
          viewBox="0 0 50 50"
          strokeWidth="4"
          strokeLinecap="round"
          fill="none"
          h={['100%', '50%']}
          transform={['scale(0.4)', 'scale(0.6)', 'scale(1)', 'scale(1)']}
        >
          <chakra.circle
            stroke="gray.500"
            opacity=".7"
            cx="25"
            cy="25"
            r="20"
          />
          <chakra.circle
            stroke="gray.900"
            strokeDasharray="130"
            strokeDashoffset="0"
            cx="25"
            cy="25"
            r="20"
            animation={`${pulse} 2s ease-in-out infinite`}
          />
        </chakra.svg>
      </Center>
    </chakra.div>
  );
}
EOT

    # Create NotFound.tsx for Chakra
    cat > "$COMPONENTS_PAGES_DIR/NotFound.tsx" << 'EOT'
'use client';

import { Box, Button, Center, Heading, Text, VStack } from '@chakra-ui/react';
import { FaExclamationTriangle } from 'react-icons/fa';

export const NotFound = () => {
  return (
    <Box w="100%" h="80vh" p={10}>
      <Center flexDir="column" h="100%">
        <VStack
          spacing={6}
          padding={8}
          backgroundColor="white"
          borderRadius="lg"
          boxShadow="2xl"
        >
          <Box as={FaExclamationTriangle} size="50px" color="red.500" />
          <Heading as="h2" size="xl" color="gray.700">
            Page Not Found
          </Heading>
          <Text fontSize="lg" color="gray.500">
            Could not find the requested resource.
          </Text>
          <Button as="a" href="/" size="lg" aria-label="Return Home">
            Return Home
          </Button>
        </VStack>
      </Center>
    </Box>
  );
};
EOT
}

generate_tailwind_files() {
    # Create layout.tsx for Tailwind
    cat > "$APP_DIR/layout.tsx" << 'EOT'
import type { Metadata } from "next";
import { ReactNode } from "react";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "My Project",
  description: "A project built by Om Gandhi",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  );
}
EOT

    # Create loading.tsx for Tailwind
    cat > "$APP_DIR/loading.tsx" << 'EOT'
'use client';

export default function Loading() {
  return (
    <div className="w-full h-[100vh]">
      <div className="flex flex-col items-center justify-center h-full">
        <svg
          viewBox="0 0 50 50"
          strokeWidth="4"
          strokeLinecap="round"
          fill="none"
          className="h-full md:h-1/2 transform scale-[0.4] md:scale-[0.6] lg:scale-100"
        >
          <circle
            stroke="gray"
            opacity=".7"
            cx="25"
            cy="25"
            r="20"
            className="stroke-gray-500"
          />
          <circle
            stroke="gray"
            cx="25"
            cy="25"
            r="20"
            className="stroke-gray-900 animate-[dash_2s_ease-in-out_infinite]"
            style={{
              strokeDasharray: 130,
              strokeDashoffset: 0,
            }}
          />
        </svg>
      </div>
    </div>
  );
}
EOT

    # Create NotFound.tsx for Tailwind
    cat > "$COMPONENTS_PAGES_DIR/NotFound.tsx" << 'EOT'
'use client';

import Link from 'next/link';
import { FaExclamationTriangle } from 'react-icons/fa';

export const NotFound = () => {
  return (
    <div className="w-full h-[80vh] p-10">
      <div className="flex flex-col items-center justify-center h-full">
        <div className="flex flex-col items-center p-8 bg-white rounded-lg shadow-2xl space-y-6">
          <FaExclamationTriangle className="text-red-500 text-[50px]" />
          <h2 className="text-2xl font-bold text-gray-700">Page Not Found</h2>
          <p className="text-lg text-gray-500">
            Could not find the requested resource.
          </p>
          <Link
            href="/"
            className="px-6 py-3 text-lg font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700"
          >
            Return Home
          </Link>
        </div>
      </div>
    </div>
  );
};
EOT
}

generate_common_files() {
    # Create not-found.tsx
    cat > "$APP_DIR/not-found.tsx" << 'EOT'
import { NotFound } from '@/components/pages/NotFound';

export default function NotFoundPage() {
  return <NotFound />;
}
EOT

    # Create page.tsx
    cat > "$APP_DIR/page.tsx" << 'EOT'
export default function Home() {
  return <div>Hello World</div>;
}
EOT

    # Create globals.css
    cat > "$APP_DIR/globals.css" << 'EOT'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --foreground-rgb: 0, 0, 0;
  --background-start-rgb: 214, 219, 220;
  --background-end-rgb: 255, 255, 255;
}

body {
  color: rgb(var(--foreground-rgb));
}

@layer utilities {
  .text-balance {
    text-wrap: balance;
  }
}
EOT

    # Update tailwind.config.ts
    cat > "$APP_DIR/tailwind.config.ts" << 'EOT'
import type { Config } from "tailwindcss";

export default {
  content: ["./app/**/*.{js,ts,jsx,tsx,mdx}", "./components/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {},
  plugins: [],
} satisfies Config;
EOT
}