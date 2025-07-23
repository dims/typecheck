# Typecheck

[![CI](https://github.com/dims/typecheck/actions/workflows/ci.yml/badge.svg)](https://github.com/dims/typecheck/actions/workflows/ci.yml)
[![Go Report Card](https://goreportcard.com/badge/github.com/dims/typecheck)](https://goreportcard.com/report/github.com/dims/typecheck)
[![codecov](https://codecov.io/gh/dims/typecheck/branch/main/graph/badge.svg)](https://codecov.io/gh/dims/typecheck)

A fast cross-platform Go typechecker that performs typechecking for all Go build platforms without requiring a full cross-compilation.

Extracted from: https://github.com/kubernetes/kubernetes/tree/master/test/typecheck

## Overview

Typecheck does cross-platform typechecking of source code for all Go build platforms. The primary benefit is speed: a full Kubernetes cross-build takes 20 minutes and >40GB of RAM, while this takes under 2 minutes and <8GB of RAM.

It uses Go's built-in parsing and typechecking libraries (`go/parser` and `go/types`), which unfortunately are not what the go compiler uses. Occasional mismatches will occur, but overall they correspond closely.

## Installation

### From Source

```bash
go install github.com/dims/typecheck@latest
```

### From Releases

Download pre-built binaries from the [releases page](https://github.com/dims/typecheck/releases).

### Using Docker

```bash
docker run --rm -v $(pwd):/workspace ghcr.io/dims/typecheck:latest-arm64 --platform linux/arm64 --verbose
```

## Usage

### Basic Usage

```bash
# Check current directory
typecheck

# Check specific packages
typecheck ./pkg/...

# Check with verbose output
typecheck -verbose ./...
```

### Cross-Platform Checking

```bash
# Check for all platforms (default)
typecheck -cross

# Check specific platforms
typecheck -platform linux/amd64,windows/amd64

# Skip cross-platform checking (current platform only)
typecheck -cross=false
```

### Advanced Options

```bash
# Parallel execution (default: 2)
typecheck -parallel 4

# Serial execution
typecheck -serial

# Skip test files
typecheck -skip-test

# With build tags
typecheck -tags integration,e2e

# Ignore specific packages
typecheck -ignore k8s.io/kubernetes/vendor/...

# Show timing information
typecheck -time

# Show definitions and uses
typecheck -defuse
```

### Options Reference

| Flag | Description | Default |
|------|-------------|---------|
| `-verbose` | Print more information | `false` |
| `-cross` | Build for all platforms | `true` |
| `-platform` | Comma-separated list of platforms to typecheck | All platforms |
| `-time` | Output times taken for each phase | `false` |
| `-defuse` | Output definitions and uses | `false` |
| `-serial` | Don't type check platforms in parallel | `false` |
| `-parallel` | Limits how many platforms can be checked in parallel (0 = no limit) | `2` |
| `-skip-test` | Don't type check test code | `false` |
| `-tags` | Comma-separated list of build tags | `""` |
| `-ignore` | Comma-separated list of Go patterns to ignore | `""` |

## Supported Platforms

- `linux/amd64`
- `linux/386`
- `linux/arm`
- `linux/arm64`
- `linux/ppc64le`
- `linux/s390x`
- `windows/386`
- `windows/amd64`
- `windows/arm64`
- `darwin/amd64`
- `darwin/arm64`

## Known Limitations

### Things go/types errors on that go build doesn't:

**True errors (according to the spec):**
These should be fixed whenever possible. Ignore if a fix isn't possible or is in progress (e.g., vendored code).
- Unused variables in closures

**False errors:**
These should be ignored and reported upstream if applicable.
- Type checking mismatches between staging and generated types

### Things go build fails on that we don't:
- CGo errors, including syntax and linker errors

## Development

### Prerequisites

- Go 1.21 or later
- Make (optional, for convenience commands)

### Building

```bash
# Build binary
make build

# Build for all platforms
make build-all

# Run tests
make test

# Run tests with coverage
make test-coverage

# Run linter
make lint

# Format code
make fmt

# Run all checks
make check
```

### Testing

```bash
# Run unit tests
go test ./...

# Run tests with race detection
go test -race ./...

# Run tests with coverage
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

### Docker

```bash
# Build Docker image
docker build -t typecheck .

# Run with Docker
docker run --rm -v $(pwd):/workspace typecheck /workspace
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and linting (`make check`)
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

## Acknowledgments

This project was originally developed as part of the Kubernetes project for fast cross-platform type checking of the Kubernetes codebase.
