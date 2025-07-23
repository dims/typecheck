# Build stage
FROM golang:1.23-alpine AS builder

# Install git for go modules
RUN apk add --no-cache git

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod go.su[m] ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o typecheck .

# Final stage
FROM alpine:latest

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

# Create non-root user
RUN addgroup -g 1001 -S typecheck && \
    adduser -u 1001 -S typecheck -G typecheck

WORKDIR /root/

# Copy the binary from builder stage
COPY --from=builder /app/typecheck .

# Change ownership to non-root user
RUN chown typecheck:typecheck typecheck

# Switch to non-root user
USER typecheck

# Command to run
ENTRYPOINT ["./typecheck"]