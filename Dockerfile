FROM python:3.9-slim
# FROM python:3.9-alpine

WORKDIR /app
ENV PYTHONPATH=/app

# Copy only inference-related files
COPY pipelines /app/pipelines/
COPY models/feature_order.pkl /app/data/models/feature_order.pkl
COPY models/mod_latest.json /app/data/models/mod_latest.json
COPY models/mod_latest.so /app/data/models/mod_latest.so
COPY models/iit_test.sqlite /app/data/models/iit_test.sqlite
COPY models/ohe_latest.pkl /app/data/models/ohe_latest.pkl
COPY models/thresholds_latest.pkl /app/data/models/thresholds_latest.pkl
COPY models/site_thresholds_latest.pkl /app/data/models/site_thresholds_latest.pkl
COPY src /app/src/
COPY data /app/data/
COPY src/common /app/src/common/
COPY src/inference /app/src/inference/
COPY requirements-inference.txt /app/

# Install only the dependencies needed for inference
# RUN apk add --no-cache build-base linux-headers gfortran cmake
RUN pip install --no-cache-dir -r requirements-inference.txt

# Set the entrypoint (adjust as needed)
CMD ["uvicorn", "src.inference.api:app", "--host", "0.0.0.0", "--port", "8000"]
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
