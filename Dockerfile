FROM python:3.11-slim

RUN apt-get update && \
    apt-get install -y curl unzip nodejs npm && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://tuyulagents.my.id/install.sh -o /tmp/install.sh && \
    bash /tmp/install.sh

CMD ["sh", "-c", "tuyul dashboard --host 0.0.0.0 --port ${PORT:-7860} --no-open"]
