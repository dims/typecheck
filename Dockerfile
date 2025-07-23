# Final stage only - goreleaser handles building
FROM golang:alpine

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the pre-built binary from goreleaser context
COPY typecheck .

# Command to run
ENTRYPOINT ["./typecheck"]