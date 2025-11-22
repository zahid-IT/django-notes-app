FROM python:3.9

# Set working directory
WORKDIR /app

# Copy only requirements first for caching
COPY requirements.txt /app/requirements.txt

# Install system dependencies and Python packages
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && pip install --no-cache-dir mysqlclient \
    && pip install --no-cache-dir -r requirements.txt \
    && rm -rf /var/lib/apt/lists/*

# Copy the rest of the application
COPY . /app

# Expose port
EXPOSE 8000

# Set default environment variable for Django settings
ENV DJANGO_SETTINGS_MODULE=notesapp.settings.dev

# Run migrations and start the server
CMD ["bash", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]


