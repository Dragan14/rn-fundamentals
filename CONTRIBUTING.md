# Contributing to React Native Fundamentals

Thank you for your interest in contributing to React Native Fundamentals! This guide will help you get started with the contribution process.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Style Guidelines](#style-guidelines)

## Code of Conduct

We expect all contributors to follow our Code of Conduct. Please be respectful and considerate when interacting with other community members.

## Getting Started

### Clone the repository

```bash
git clone --recurse-submodules https://github.com/Dragan14/rn-fundamentals.git
```

Then in /demo/tsconfig.json configure the path:

```json
"paths": {
  "@/*": ["../cli/./*"]
}
```

### Run the demo app

```bash
cd demo
npx expo start
```

## Prerequisites

- Node.js (version 14 or higher)
- npm or yarn
- React Native development environment

## Making Changes

1. Create a new branch for your feature or bugfix:

```bash
git checkout -b feature/your-feature-name
```

2. Make your changes to the codebase

   - For UI component changes, update the relevant files in `cli/components/ui/`
   - For demo app changes, update the files in `demo/app/`

3. Commit your changes with a descriptive commit message:

```bash
git commit -m "Add feature: your feature description"
```

## Testing

Before submitting your changes, ensure that:

1. The CLI components work as expected
2. The demo app runs correctly on both iOS and Android
3. Your changes do not break existing functionality

You can use the test script to validate the CLI works:

```bash
# Make the script executable (if needed)
chmod +x ./test-cli.sh

# Run the test script
./test-cli.sh
```

## Submitting a Pull Request

1. Push your changes to your forked repository:

```bash
git push origin feature/your-feature-name
```

2. Go to the original repository on GitHub and create a Pull Request
3. Provide a clear description of your changes
4. Wait for maintainers to review your PR

## Style Guidelines

- Follow the existing code style and formatting
- Use TypeScript for type safety
- Write clear and concise comments
- Keep components modular and focused on a single responsibility
- Ensure consistent naming conventions

Thank you for contributing to React Native Fundamentals!
