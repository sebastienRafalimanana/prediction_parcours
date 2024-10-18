# Utiliser une image de base Python
FROM python:3.9-slim

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copier les fichiers nécessaires pour l'application dans le conteneur
COPY requirements.txt requirements.txt
COPY . .

# Installer les dépendances
RUN pip install --no-cache-dir -r requirements.txt

# Exposer le port utilisé par l'application Flask
EXPOSE 5000


CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "wsgi:app"]
