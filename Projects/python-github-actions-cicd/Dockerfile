FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY app.py .

# Run the application as a non-root user.
RUN useradd --create-home --uid 10001 appuser
USER appuser

EXPOSE 8080

CMD ["python", "app.py"]
