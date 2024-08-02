FROM python:3.9-slim
WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y git
COPY . .
RUN pip install --no-cache-dir jinja2
CMD ["sh", "-c", "python generate_release_notes.py /usr/src/app && cat /usr/src/app/release_notes.md"]
