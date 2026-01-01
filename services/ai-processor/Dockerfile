FROM python:3.12-slim

WORKDIR /App

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Env var to ensure logs are visible
ENV PYTHONUNBUFFERED=1

CMD ["python", "main.py"]
