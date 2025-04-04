# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands
- Build Docker image: `./build.sh`
- Push Docker image to ECR: `./push.sh`

## Code Style Guidelines

### Shell Scripts
- Start with `#!/bin/bash`
- Use `set -e` to exit on error
- Use consistent indentation (2 spaces)
- Variable names should be UPPER_SNAKE_CASE
- Descriptive echo statements with emoji prefixes for visibility

### Docker/Containerization
- Use Alpine-based images when possible
- Document each significant step with comments
- Set the working directory with WORKDIR
- Tag images with both latest and git SHA

### Error Handling
- Always include error handling in shell scripts with `set -e`
- Add descriptive error messages

### Commit Messages
- Write clear, concise messages describing changes
- Use present tense ("Add feature" not "Added feature")