# Build stage
FROM docker.io/rust:alpine AS builder

# Install build dependencies
RUN apk add --no-cache musl-dev

# Create app directory
WORKDIR /usr/src/app

# Copy source code
COPY . .

# Build the application
RUN cargo build --release

# Runtime stage
FROM docker.io/alpine

# Install runtime dependencies
RUN apk add --no-cache ca-certificates

# Create non-root user
RUN adduser -D -s /bin/sh miniserve

# Create app directory and set ownership
RUN mkdir -p /app && chown miniserve:miniserve /app
RUN mkdir -p /data && chown miniserve:miniserve /data

# Copy the built binary from builder stage
COPY --from=builder --chown=miniserve:miniserve /usr/src/app/target/release/miniserve /app/miniserve

# Switch to non-root user
USER miniserve

# Set working directory
WORKDIR /app

# Expose port 8080 (non-privileged port)
EXPOSE 8080

ENTRYPOINT ["/app/miniserve", "/data"]
