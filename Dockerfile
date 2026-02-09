services:
  - type: web
    name: nextcloud
    env: docker
    plan: starter
    autoDeploy: true
    disk:
      name: nextcloud-data
      mountPath: /var/www/html
      sizeGB: 10
    envVars:
      - key: POSTGRES_DB
        value: nextcloud
      - key: POSTGRES_USER
        value: nextcloud
      - key: POSTGRES_PASSWORD
        generateValue: true
      - key: POSTGRES_HOST
        fromService:
          type: pserv
          name: nextcloud-db
          property: host

  - type: pserv
    name: nextcloud-db
    env: docker
    plan: starter
    disk:
      name: nextcloud-db-data
      mountPath: /var/lib/postgresql/data
      sizeGB: 10
    image:
      url: postgres:15
    envVars:
      - key: POSTGRES_DB
        value: nextcloud
      - key: POSTGRES_USER
        value: nextcloud
      - key: POSTGRES_PASSWORD
        generateValue: true
