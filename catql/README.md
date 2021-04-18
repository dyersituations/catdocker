## Docker Setup
- Create `.env`
  ````
  HASURA_GRAPHQL_ADMIN_SECRET=<password>
  ````

## Hasura Setup

- Install Hasura CLI
- Create `config.yaml`
  ````
  version: 2
  endpoint: http://localhost:8080
  admin_secret: <password> # Match HASURA_GRAPHQL_ADMIN_SECRET
  metadata_directory: metadata
  actions:
    kind: synchronous
    handler_webhook_baseurl: http://localhost:3000
  ````

## Using Hasura CLI

Run commands from `hasura` folder.

- `hasura console`
- `hasura migrate apply`
- `hasura metadata apply`
- `hasura migrate squash --from <number>`
