# Final stage only - goreleaser handles building
FROM golang:alpine

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

WORKDIR /workspace/

COPY typecheck /

# Command to run
ENTRYPOINT ["/typecheck"]