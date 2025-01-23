FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl3 \
    ca-certificates \
    wget \
    gzip \
    libpq5 \
    nginx \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download and extract ibis binary
RUN wget https://github.com/Nutomic/ibis/releases/latest/download/ibis.gz && \
    gzip -d ibis.gz && \
    chmod +x ibis

# Copy config and nginx config
COPY config.toml /app/config.toml
COPY nginx.conf /etc/nginx/nginx.conf

# Create ibis user and nginx directories
RUN useradd -r -s /bin/false ibis && \
    mkdir -p /var/lib/nginx /var/log/nginx && \
    chown ibis:ibis /app -R && \
    chown ibis:ibis /var/lib/nginx /var/log/nginx && \
    touch /var/log/nginx/access.log /var/log/nginx/error.log && \
    chown ibis:ibis /var/log/nginx/*.log

USER ibis

# Disable nginx logging to files since we're running in a container
RUN sed -i '/access_log/d' /etc/nginx/nginx.conf && \
    sed -i '/error_log/d' /etc/nginx/nginx.conf

EXPOSE 8081
EXPOSE 3000
CMD ["sh", "-c", "nginx -c /etc/nginx/nginx.conf && ./ibis"]
