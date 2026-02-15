FROM python:3.9-slim

# Impede que o Python gere arquivos .pyc e permite logs em tempo real
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PORT 8000

WORKDIR /app

# Instala apenas o essencial e limpa o cache para reduzir o tamanho da imagem
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copia e instala dependências
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copia o restante do código
COPY . /app/

# Coleta estáticos e garante que a pasta exista
RUN python manage.py collectstatic --noinput

# Expõe a porta
EXPOSE 8000

# Comando de inicialização apontando para sua pasta setup
CMD gunicorn setup.wsgi:application --bind 0.0.0.0:$PORT