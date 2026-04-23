# Contributing to Super Scrcpy

Thank you for your interest in contributing to Super Scrcpy! This document explains how to engage with the project, report issues, propose improvements, and submit pull requests in a way that helps the maintainers review and merge your work quickly.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Report Bugs](#how-to-report-bugs)
- [How to Request Features](#how-to-request-features)
- [How to Contribute Code](#how-to-contribute-code)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Pull Request Checklist](#pull-request-checklist)
- [Community Guidelines](#community-guidelines)
- [Security](#security)

## Code of Conduct

All contributors must follow the project’s [Code of Conduct](CODE_OF_CONDUCT.md). Please be respectful, courteous, and professional in all interactions.

## Getting Started

Before creating an issue or pull request, please:

1. Search existing issues to avoid duplicates.
2. Review the [README](README.md) for usage details and project structure.
3. Confirm the bug or feature request is not already covered in an open issue.

### Setup your environment

Clone the repository and install dependencies:

```bash
git clone https://github.com/anandssm/super_scrcpy.git
cd super_scrcpy
flutter pub get
```

For local development, make sure you have a compatible Flutter SDK installed (`>= 3.10.4`).

## How to Report Bugs

When reporting a bug, please use the bug report issue template to provide the following:

- What happened and what you expected.
- Exact steps to reproduce the problem.
- Device / platform details (Windows/macOS/Linux, Flutter version).
- Any error messages, logs, or screenshots.
- Whether the bug is reproducible consistently.

A clear bug report helps maintainers fix issues faster.

## How to Request Features

Feature requests should explain:

- The problem you are trying to solve.
- Why it is important.
- How the feature would behave.
- Any specific design or workflow ideas.

Use the feature request issue template so maintainers can evaluate and discuss the improvement.

## How to Contribute Code

### Branching

Use a descriptive branch name for your work:

```bash
git checkout -b feature/add-wireless-pairing
# or
git checkout -b fix/device-detection
```

### Commit messages

Use clear, concise commit messages. Prefer the format:

- `feat: ` for new features
- `fix: ` for bug fixes
- `docs: ` for documentation changes
- `chore: ` for maintenance updates

### Code style

- Follow Dart and Flutter conventions.
- Run `dart format` on modified files.
- Keep changes focused and avoid broad refactors in the same PR.

### Documentation

If your change adds or alters behavior, update the README or other documentation as needed.

## Development Workflow

1. Create a new branch from `main`.
2. Make your changes.
3. Run tests and format your code.
4. Commit with a descriptive message.
5. Push your branch and open a pull request.

## Testing

Run the following commands before submitting a PR:

```bash
flutter test
flutter analyze
flutter format .
```

If your change affects only UI or platform-specific behavior, include steps for reviewers to verify it manually.

## Pull Request Checklist

Please complete this checklist before requesting review:

- [ ] I have checked for existing issues or PRs related to this change.
- [ ] My changes are limited to a single purpose and are easy to review.
- [ ] I have run `flutter analyze` and fixed any warnings or errors.
- [ ] I have run `flutter test` and verified tests pass.
- [ ] I have formatted my code with `dart format`.
- [ ] I have updated documentation where appropriate.
- [ ] I have included issue references if applicable.

## Community Guidelines

- Be patient and polite throughout the review process.
- Accept constructive feedback and revise your PR accordingly.
- If you are unsure how to proceed, ask for guidance in a comment.

## Security

For security vulnerabilities, do not open a public issue. Please follow the process described in [SECURITY.md](SECURITY.md).
