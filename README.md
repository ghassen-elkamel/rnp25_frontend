## Start Commands for docker-compose file and information

Builds, (re)creates, starts, and attaches to containers for a service.

````
 docker compose -f docker-compose.yml up```

## Reload container, add package

````

docker compose -f docker-compose.yml build --no-cache

docker compose -f docker-compose.yml up --build -V

```

## Docker - Create Image

```

docker build -t backend .

```

## Create an empty migration

```

npx typeorm migration:create src/db/migrations/name_of_migration

```

## Generate migration

1- Get the name of the existing container

```

docker ps

```
2- Get a bash shell in the container

```

docker exec -it <container name> /bin/bash

```

3- Generate the migration

```

npx typeorm migration:generate src/db/migrations/update_user -d dist/db/data-source.js

```
4- Excecute the migration

```
npx typeorm migration:run -d dist/db/data-source.js

## Migration callback
```

npx typeorm migration:revert -d dist/db/data-source.js

```

## Create seeder

```

npx typeorm migration:create src/db/seeders/categories

```

## Prettier formater

```

npx prettier --write .

```
## Update .env on prod

```

kubectl delete -f xchange_backend.yaml && kubectl apply -f xchange_backend.yaml

```

```
