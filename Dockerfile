FROM python:3.11-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    nodejs \
    npm \
    ca-certificates \
    findutils && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://tuyulagents.my.id/install.sh -o /tmp/install.sh && \
    bash /tmp/install.sh && \
    echo "=== CHECK TUYUL ===" && \
    if command -v tuyul >/dev/null 2>&1; then \
        echo "Tuyul found: $(command -v tuyul)"; \
    else \
        echo "Tuyul not in PATH, searching filesystem..." && \
        TUYUL_BIN="$(find / -type f -name tuyul -perm /111 2>/dev/null | head -n 1)" && \
        if [ -z "$TUYUL_BIN" ]; then \
            echo "ERROR: TUYUL EXECUTABLE NOT FOUND"; \
            echo "=== PATH ==="; \
            echo "$PATH"; \
            echo "=== ROOT FILES ==="; \
            ls -la /root || true; \
            exit 1; \
        fi && \
        echo "Found Tuyul: $TUYUL_BIN" && \
        ln -sf "$TUYUL_BIN" /usr/local/bin/tuyul; \
    fi && \
    chmod +x /usr/local/bin/tuyul && \
    echo "=== FINAL TUYUL CHECK ===" && \
    /usr/local/bin/tuyul --help >/dev/null

EXPOSE 7860

CMD ["sh", "-c", "echo \"Starting Tuyul on port ${PORT:-7860}\" && /usr/local/bin/tuyul dashboard --host 0.0.0.0 --port ${PORT:-7860} --no-open"]
