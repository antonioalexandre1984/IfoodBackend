FROM python:3.9-slim-buster
ENV PYTHONUNBUFFERED 1

# Define a porta padrão (o Render injetará a dele, mas isso serve de fallback)
ENV PORT 8000

RUN mkdir /app
WORKDIR /app
ADD . /app/

# Instala as dependências
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expõe a porta para o mundo externo
EXPOSE 8000

# Comando para rodar a aplicação usando gunicorn
# Substitua 'nome_do_seu_projeto' pelo nome da pasta que contém o arquivo wsgi.py
CMD gunicorn setup.wsgi:application --bind 0.0.0.0:$PORT