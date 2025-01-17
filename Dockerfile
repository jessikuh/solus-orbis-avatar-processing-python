FROM python:3.9.5-slim-buster

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH="/app" \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1

# Add poetry path variable
ENV PATH="$POETRY_HOME/bin:$PATH"

RUN apt-get update \
  && apt-get install -y curl sudo zip \
  && apt-get clean

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  sudo ./aws/install

# Install poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
RUN poetry config virtualenvs.create false

COPY ./app/pyproject.toml ./app/poetry.lock* ./
RUN poetry install

EXPOSE 8000

COPY ./app ./

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]