# Final stage only - goreleaser handles building
FROM golang:alpine

# Install ca-certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

# Create non-root user
RUN addgroup -g 1001 -S typecheck && \
    adduser -u 1001 -S typecheck -G typecheck

WORKDIR /root/

# Copy the pre-built binary from goreleaser context
COPY typecheck .

# Change ownership to non-root user
RUN chown typecheck:typecheck typecheck

# Switch to non-root user
USER typecheck

# Command to run
ENTRYPOINT ["./typecheck"]