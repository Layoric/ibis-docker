FROM rust:1.81-slim-bullseye as builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm
ENV SHELL=/bin/bash
RUN curl -fsSL https://get.pnpm.io/install.sh | sh -
ENV PATH="/root/.local/share/pnpm:$PATH"

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
