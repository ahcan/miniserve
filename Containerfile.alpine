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

# Copy the built binary from builder stage
COPY --from=builder --chmod=755 /usr/src/app/target/release/miniserve /app/

ENTRYPOINT ["/app/miniserve"]
