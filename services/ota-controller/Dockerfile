FROM python:3.12-alpine
WORKDIR /app
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
COPY . /app
EXPOSE 7070
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7070"]
