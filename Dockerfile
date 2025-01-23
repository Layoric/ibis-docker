FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    ca-certificates \
    wget \
    gzip \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download and extract ibis binary
RUN wget https://github.com/Nutomic/ibis/releases/latest/download/ibis.gz && \
    gzip -d ibis.gz && \
    chmod +x ibis

# Copy config if it exists
COPY config.toml /app/config.toml

# Create ibis user
RUN useradd -r -s /bin/false ibis && \
    chown ibis:ibis /app -R

USER ibis

EXPOSE 8081
CMD ["./ibis"]
