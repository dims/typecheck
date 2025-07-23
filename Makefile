.PHONY: build test clean lint fmt vet install help

# Binary name
BINARY_NAME=typecheck

# Build the binary
build:
	go build -o $(BINARY_NAME) .

# Run tests
test:
	go test -v ./...

# Run tests with coverage
test-coverage:
	go test -v -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

# Clean build artifacts
clean:
	go clean
	rm -f $(BINARY_NAME)
	rm -f coverage.out coverage.html

# Lint the code
lint:
	golangci-lint run

# Format the code
fmt:
	go fmt ./...

# Vet the code
vet:
	go vet ./...

# Install dependencies
deps:
	go mod download
	go mod tidy

# Install the binary
install:
	go install .

# Run all checks
check: fmt vet lint test

# Build for multiple platforms
build-all:
	GOOS=linux GOARCH=amd64 go build -o dist/$(BINARY_NAME)-linux-amd64 .
	GOOS=windows GOARCH=amd64 go build -o dist/$(BINARY_NAME)-windows-amd64.exe .
	GOOS=darwin GOARCH=amd64 go build -o dist/$(BINARY_NAME)-darwin-amd64 .
	GOOS=darwin GOARCH=arm64 go build -o dist/$(BINARY_NAME)-darwin-arm64 .

# Create dist directory
dist:
	mkdir -p dist

# Release build
release: clean dist build-all

# Help
help:
	@echo "Available commands:"
	@echo "  build        - Build the binary"
	@echo "  test         - Run tests"
	@echo "  test-coverage - Run tests with coverage report"
	@echo "  clean        - Clean build artifacts"
	@echo "  lint         - Run linter"
	@echo "  fmt          - Format code"
	@echo "  vet          - Run go vet"
	@echo "  deps         - Install dependencies"
	@echo "  install      - Install binary"
	@echo "  check        - Run all checks (fmt, vet, lint, test)"
	@echo "  build-all    - Build for multiple platforms"
	@echo "  release      - Create release builds"
	@echo "  help         - Show this help"