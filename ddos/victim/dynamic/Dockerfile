FROM python:3.10-slim

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

# Specify the number of workers for a more realistic approach, dynamically specify number of workers for maximum availability
CMD ["sh", "-c", "gunicorn -w $(expr 2 \\* $(nproc) + 1) -b 0.0.0.0:5000 app:app"]