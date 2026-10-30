-- Exécuté une seule fois, à la création du volume de données.
-- La bibliothèque pgaudit est chargée par le paramètre shared_preload_libraries
-- défini dans docker-compose.demo-db.yml.
CREATE EXTENSION IF NOT EXISTS pgaudit;
