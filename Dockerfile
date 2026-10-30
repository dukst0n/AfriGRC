# Image PostgreSQL de démo avec l'extension pgaudit (journal d'audit des accès).
# On utilise l'image Debian (pas Alpine) car le paquet pgaudit y est disponible.
# Vérifier la version de PostgreSQL et le nom du paquet à l'installation.
FROM postgres:16

RUN apt-get update \
 && apt-get install -y --no-install-recommends postgresql-16-pgaudit \
 && rm -rf /var/lib/apt/lists/*
