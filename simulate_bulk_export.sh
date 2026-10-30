#!/usr/bin/env bash
# Simule une extraction massive de la table clients (scénario de démo).
# Génère des lignes "AUDIT:" dans le journal de la base, que le futur module
# de surveillance (Phase 6) reliera au catalogue : table classée données
# personnelles -> obligation légale -> écart à ouvrir.
#
# Usage : ./simulate_bulk_export.sh
set -euo pipefail

CONTAINER="${CONTAINER:-afrigrc-demo-db}"

echo "Extraction massive simulée de la table clients..."
docker exec -e PGPASSWORD=demo_change_me "$CONTAINER" \
  psql -U demo -d pme_sn -c "COPY (SELECT * FROM clients) TO STDOUT WITH CSV HEADER" > /dev/null

echo "Consultation ciblée d'un employé (santé, salaire)..."
docker exec -e PGPASSWORD=demo_change_me "$CONTAINER" \
  psql -U demo -d pme_sn -c "SELECT nom, salaire_fcfa, etat_sante_note FROM employes LIMIT 5;" > /dev/null

echo
echo "Événements d'audit enregistrés :"
docker logs "$CONTAINER" 2>&1 | grep "AUDIT:" | tail -n 5
