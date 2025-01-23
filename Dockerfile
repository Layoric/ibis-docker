FROM rust:1.82-slim-bullseye as builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and pnpm
ENV SHELL=/bin/bash
RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g pnpm
ENV PATH="/root/.local/share/pnpm:$PATH"
ENV LEPTOS_TAILWIND_VERSION=v4.0.0

# Install wasm target
RUN rustup target add wasm32-unknown-unknown

# Install cargo-leptos
RUN cargo install cargo-leptos --locked

# Clone the Ibis repository
WORKDIR /app
RUN git clone https://github.com/Nutomic/ibis.git . && \
    pnpm install && \
    cargo leptos build --release

# Final image
FROM debian:bullseye-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/target/release/ibis /app/ibis
# Copy config if it exists
COPY config.toml /app/config.toml

# Create ibis user
RUN useradd -r -s /bin/false ibis && \
    chown ibis:ibis /app -R

USER ibis

EXPOSE 8081
CMD ["./ibis"]
