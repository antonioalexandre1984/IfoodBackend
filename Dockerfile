FROM python:3.9-slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PORT 8000

WORKDIR /app

# Instala dependências do sistema necessárias para Pillow e outras libs
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . /app/

# Coleta arquivos estáticos (importante para o painel administrativo funcionar)
RUN python manage.py collectstatic --noinput

# Expõe a porta
EXPOSE 8000

# Comando usando a sua pasta 'setup'
CMD gunicorn setup.wsgi:application --bind 0.0.0.0:$PORT