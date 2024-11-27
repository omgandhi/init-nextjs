#!/bin/bash

generate_project_files() {
    local ui_library=$1

    log_info "Generating project files..."

    # Generate ESLint config
    echo "$ESLINT_CONFIG" > .eslintrc.json

    # Generate other files based on UI library choice
    if [ "$ui_library" == "chakra" ]; then
        generate_chakra_files
        update_chakra_snippets
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

update_chakra_snippets() {
    # Dialog
    cat > "$COMPONENTS_DIR/ui/Dialog.tsx" << 'EOT'
import * as React from 'react';

import { Dialog as ChakraDialog, Portal } from '@chakra-ui/react';
import {CloseButton} from "@/components/ui/CloseButton";

interface DialogContentProps extends ChakraDialog.ContentProps {
  portalled?: boolean;
  portalRef?: React.RefObject<HTMLElement>;
  backdrop?: boolean;
}

export const DialogContent = React.forwardRef<
  HTMLDivElement,
  DialogContentProps
>(function DialogContent(props, ref) {
  const {
    children,
    portalled = true,
    portalRef,
    backdrop = true,
    ...rest
  } = props;

  return (
    <Portal disabled={!portalled} container={portalRef}>
      {backdrop && <ChakraDialog.Backdrop />}
      <ChakraDialog.Positioner>
        <ChakraDialog.Content ref={ref} {...rest} asChild={false}>
          {children}
        </ChakraDialog.Content>
      </ChakraDialog.Positioner>
    </Portal>
  );
});

export const DialogCloseTrigger = React.forwardRef<
  HTMLButtonElement,
  ChakraDialog.CloseTriggerProps
>(function DialogCloseTrigger(props, ref) {
  return (
    <ChakraDialog.CloseTrigger
      position="absolute"
      top="2"
      insetEnd="2"
      {...props}
      asChild
    >
      <CloseButton size="sm" ref={ref}>
        {props.children}
      </CloseButton>
    </ChakraDialog.CloseTrigger>
  );
});

export const DialogRoot = ChakraDialog.Root;
export const DialogFooter = ChakraDialog.Footer;
export const DialogHeader = ChakraDialog.Header;
export const DialogBody = ChakraDialog.Body;
export const DialogBackdrop = ChakraDialog.Backdrop;
export const DialogTitle = ChakraDialog.Title;
export const DialogDescription = ChakraDialog.Description;
export const DialogTrigger = ChakraDialog.Trigger;
export const DialogActionTrigger = ChakraDialog.ActionTrigger;
EOT

    # Drawer
    cat > "$COMPONENTS_DIR/ui/Drawer.tsx" << 'EOT'
import * as React from 'react';

import { Drawer as ChakraDrawer, Portal } from '@chakra-ui/react';
import {CloseButton} from "@/components/ui/CloseButton";

interface DrawerContentProps extends ChakraDrawer.ContentProps {
  portalled?: boolean;
  portalRef?: React.RefObject<HTMLElement>;
  offset?: ChakraDrawer.ContentProps['padding'];
}

export const DrawerContent = React.forwardRef<
  HTMLDivElement,
  DrawerContentProps
>(function DrawerContent(props, ref) {
  const { children, portalled = true, portalRef, offset, ...rest } = props;
  return (
    <Portal disabled={!portalled} container={portalRef}>
      <ChakraDrawer.Positioner padding={offset}>
        <ChakraDrawer.Content ref={ref} {...rest} asChild={false}>
          {children}
        </ChakraDrawer.Content>
      </ChakraDrawer.Positioner>
    </Portal>
  );
});

export const DrawerCloseTrigger = React.forwardRef<
  HTMLButtonElement,
  ChakraDrawer.CloseTriggerProps
>(function DrawerCloseTrigger(props, ref) {
  return (
    <ChakraDrawer.CloseTrigger
      position="absolute"
      top="2"
      insetEnd="2"
      {...props}
      asChild
    >
      <CloseButton size="sm" ref={ref} />
    </ChakraDrawer.CloseTrigger>
  );
});

export const DrawerTrigger = ChakraDrawer.Trigger;
export const DrawerRoot = ChakraDrawer.Root;
export const DrawerFooter = ChakraDrawer.Footer;
export const DrawerHeader = ChakraDrawer.Header;
export const DrawerBody = ChakraDrawer.Body;
export const DrawerBackdrop = ChakraDrawer.Backdrop;
export const DrawerDescription = ChakraDrawer.Description;
export const DrawerTitle = ChakraDrawer.Title;
export const DrawerActionTrigger = ChakraDrawer.ActionTrigger;
EOT

    # Popover
    cat > "$COMPONENTS_DIR/ui/Popover.tsx" << 'EOT'
import * as React from 'react';

import { Popover as ChakraPopover, Portal } from '@chakra-ui/react';
import {CloseButton} from "@/components/ui/CloseButton";

interface PopoverContentProps extends ChakraPopover.ContentProps {
  portalled?: boolean;
  portalRef?: React.RefObject<HTMLElement>;
}

export const PopoverContent = React.forwardRef<
  HTMLDivElement,
  PopoverContentProps
>(function PopoverContent(props, ref) {
  const { portalled = true, portalRef, ...rest } = props;
  return (
    <Portal disabled={!portalled} container={portalRef}>
      <ChakraPopover.Positioner>
        <ChakraPopover.Content ref={ref} {...rest} />
      </ChakraPopover.Positioner>
    </Portal>
  );
});

export const PopoverArrow = React.forwardRef<
  HTMLDivElement,
  ChakraPopover.ArrowProps
>(function PopoverArrow(props, ref) {
  return (
    <ChakraPopover.Arrow {...props} ref={ref}>
      <ChakraPopover.ArrowTip />
    </ChakraPopover.Arrow>
  );
});

export const PopoverCloseTrigger = React.forwardRef<
  HTMLButtonElement,
  ChakraPopover.CloseTriggerProps
>(function PopoverCloseTrigger(props, ref) {
  return (
    <ChakraPopover.CloseTrigger
      position="absolute"
      top="1"
      insetEnd="1"
      {...props}
      asChild
      ref={ref}
    >
      <CloseButton size="sm" />
    </ChakraPopover.CloseTrigger>
  );
});

export const PopoverTitle = ChakraPopover.Title;
export const PopoverDescription = ChakraPopover.Description;
export const PopoverFooter = ChakraPopover.Footer;
export const PopoverHeader = ChakraPopover.Header;
export const PopoverRoot = ChakraPopover.Root;
export const PopoverBody = ChakraPopover.Body;
export const PopoverTrigger = ChakraPopover.Trigger;
EOT

    # Provider
    cat > "$COMPONENTS_DIR/ui/Provider.tsx" << 'EOT'
'use client';

import { ChakraProvider, defaultSystem } from '@chakra-ui/react';
import {ColorModeProvider, ColorModeProviderProps} from "@/components/ui/ColorMode";

export function Provider(props: ColorModeProviderProps) {
  return (
    <ChakraProvider value={defaultSystem}>
      <ColorModeProvider {...props} />
    </ChakraProvider>
  );
}
EOT
}

generate_chakra_files() {
    # Create layout.tsx for Chakra
    cat > "$APP_DIR/layout.tsx" << 'EOT'
import type { Metadata } from "next";
import { ReactNode } from "react";
import { Inter } from "next/font/google";
import {Provider} from "@/components/ui/Provider";

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
        <Provider>
          {children}
        </Provider>
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

    # Create page.tsx
    cat > "$APP_DIR/page.tsx" << 'EOT'
import {Box} from "@chakra-ui/react";

export default function Home() {
  return <Box>Hello World!</Box>;
}
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

    # Create globals.css
    cat > "$APP_DIR/globals.css" << 'EOT'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Modern scrollbar styling */
@layer base {
    ::-webkit-scrollbar {
        width: 14px;
    }

    ::-webkit-scrollbar-track {
        @apply bg-transparent;
    }

    ::-webkit-scrollbar-thumb {
        @apply bg-gray-300 dark:bg-gray-600 border-4 border-solid border-transparent bg-clip-padding rounded-full;
    }

    ::-webkit-scrollbar-thumb:hover {
        @apply bg-gray-400 dark:bg-gray-500;
    }

    /* Firefox */
    * {
        scrollbar-width: thin;
        scrollbar-color: theme('colors.gray.300') transparent;
    }

    .dark * {
        scrollbar-color: theme('colors.gray.600') transparent;
    }
}

/* Better text rendering */
@layer base {
    html {
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        @apply overflow-y-scroll;
    }
}

/* Focus styles */
@layer base {
    *:focus-visible {
        @apply outline-none ring-2 ring-blue-500 ring-offset-2 ring-offset-white dark:ring-offset-gray-900;
    }
}

/* Text selection */
@layer base {
    ::selection {
        @apply bg-blue-500 text-white;
    }
}

/* Dark mode transitions */
@layer base {
    * {
        @apply transition-colors duration-200;
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

    # Create page.tsx
    cat > "$APP_DIR/page.tsx" << 'EOT'
export default function Home() {
  return (
    <main>
      <div>Hello world!</div>
    </main>
  );
}
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
}