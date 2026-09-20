FROM python:3.11-slim

# تثبيت المتطلبات
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# تثبيت uv
RUN curl -fsSL https://astral.sh/uv/install.sh | bash
ENV PATH="/root/.local/bin:$PATH"

# نسخ ملفات المشروع
WORKDIR /app
COPY . .

# تثبيت Hermes
RUN uv pip install --system hermes-agent

# تشغيل Hermes gateway
CMD ["hermes", "gateway", "run"]
