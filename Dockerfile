FROM denoland/deno:latest AS base

# Create a non-root user with UID 1001
RUN groupadd -g 1001 appgroup && \
    useradd -r -u 1001 -g appgroup appuser

# Set the working directory inside the container
WORKDIR /app

# Copy application files first (as root for proper permissions)
COPY . .

# Ensure the app directory is owned by the non-root user
RUN chown -R 1001:1001 /app

# Switch to non-root user
USER 1001

# Set deno cache directory
ENV DENO_DIR=/app/.cache/deno

# Ensure the schemas directory exists and is writable
# (it will be overridden by PVC mount in Kubernetes)

# Run the server
CMD ["deno", "run", "--allow-net", "--allow-env", "--allow-read", "--allow-write", "server.ts"]
