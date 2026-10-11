# TraceFresh

Food recall traceability system: when a supplier batch is found unsafe,
TraceFresh finds every store that received it, notifies them, and tracks
confirmation that the product was removed from shelves.

## Architecture (planned)

- **recall-service** — Spring Boot (Java 21): suppliers, products, batches, shipments, recalls
- **notification-service** — Spring Boot (Java 21): consumes recall events, notifies stores
- **frontend** — React + TypeScript (Vite)
- **lambda-csv-import** — AWS Lambda: bulk shipment import from CSV
- **Messaging** — SNS + SQS (LocalStack locally)
- **Database** — PostgreSQL (Docker locally, RDS on AWS)

## Status

Work in progress.