#!/bin/bash
set -e

# La imagen oficial de mysql solo otorga privilegios a MYSQL_USER sobre la
# base MYSQL_DATABASE. Esta app crea una base nueva por tenant
# (config/tenancy.php: prefix + '_' + id, prefix default 'tenancy'), asi que
# el usuario de la app necesita permiso para crear/administrar cualquier base
# que empiece con ese prefijo. Los scripts en /docker-entrypoint-initdb.d/
# solo corren una vez, cuando el volumen de datos esta vacio (primer arranque).
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    GRANT ALL PRIVILEGES ON \`${TENANT_DB_PREFIX:-tenancy}\_%\`.* TO '$MYSQL_USER'@'%';
    FLUSH PRIVILEGES;
EOSQL
