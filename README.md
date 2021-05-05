> Los nombres usados en este readme deberían modificarse por la imagen real. Que
> dependerá de la registry seleccionada, la organización usada por SIU (si es
> dockerhub) y el nombre de la imagen definitiva. En mi opinión, el nombre
> debería ser siu/php

# Imagen base SIU php

Este repositorio contiene el código necesario para construir imágenes de
contenedores basadas en php en diferentes versiones del lenguaje:

* [ ] 7.1
* [ ] 7.3
* [x] 7.4
* [ ] 8.0

En cada versión, se proveen versiones para:

* **cli:** intérprete de php para utilizarse en scripts que no requieran un web
  server.
* **web:** igual imagen que la cli, pero agrega el servicio de apache2 y
  configura el módulo de apache para integrarse con PHP. En este caso, se
  instancia automáticamente el servicio de apache en foreground y los logs se
  redirigen a la salida estándar.
* **web-rootless:** igual a la web, pero corre con un usuario no privilegiado.

* [Acerca del entrypoint](#acerca-del-entrypoint)
* [Imagen Rootless](#imagen-rootless)
* [Usos de la imagen](#usos-de-la-imagen)
  * [Extendiendo configuraciones con volúmenes locales](#extendiendo-configuraciones-con-volúmenes-locales)
  * [Extendiendo configuraciones con build de imagen](#extendiendo-configuraciones-con-build-de-imagen)


## Acerca del entrypoint

El entrypoint en la imagen cli se hereda de la imagen base, siendo un shell.
Para el servicio web, es el servicio de apache el que tendrá el pid 1. Sin
embargo, previo a su invocación, se recorren todos los scripts que se desee
agregar para correr antes de iniciar el servicio.

## Imagen Rootless

Esta imagen utiliza un usuario no privilegiado para correr. La imagen crea un
usuario que por defecto se parametriza es siu

## Usos de la imagen

La imagen puede extenderse mediante configuraciones que deban agregarse a php o
apache, como además agregando fuentes, instalando librerías, y demás cuestiones
que serán necesarias según el proyecto que deba emplear la imagen. Por ello,
cada escenario será muy particular y podrá seguir alguna de las prácticas
debajo mencionadas:

### Extendiendo configuraciones con volúmenes locales

Esta práctica aplica a volumenes desde el filesystem, pero también aplica a
swarm configs, secrets o kubernetes configmap o secrets.

Para poder mostrar como parametrizar un valor del php.ini, cambiaremos la
configuración de `memory_limit`. Primero verificamos el valor actual:

```bash
docker run --rm \
  siutoba/php:cli-7.4 php -r 'echo ini_get("memory_limit")."\n";'
```

Usando un volumen:

```bash
echo "memory_limit = 64M" > /tmp/custom.ini && \
  docker run \
    -v /tmp/custom.ini:/etc/php7/conf.d/90-custom.ini \
    --rm \
    siutoba/php:cli-7.4 php -r 'echo ini_get("memory_limit")."\n";'
```

Usando un config de swarm:

```bash
# Crea un ini custom
echo "memory_limit = 64M" > /tmp/custom.ini

# Creamos un stack de swarm
cat <<COMPOSE > /tmp/siu-stack.yml
version: "3.9"
services:
  web:
    image: siutoba/php:web-7.4
    deploy:
      replicas: 1
    configs:
      - source: siu-demo-ini
        target: /etc/php7/conf.d/99-custom.ini
configs:
  siu-demo-ini:
    file: /tmp/custom.ini
COMPOSE

# Asumimos ya existe un cluster swarm. Entonces cargamos este stack de ejemplo
docker stack deploy --compose-file /tmp/siu-stack.yml siu

# Verificamos el valor del php.ini
docker exec -it $(docker ps -q -f name=siu_web) \
  php -r 'echo ini_get("memory_limit");'
```

### Extendiendo configuraciones con build de imagen

Podemos crear una nueva imagen a partir de alguna de las imagenes de base, y
cargar cuantas personalizaciones querramos.

> Si las personalizaciones dependen en runtime, se debe pensar poder
> parametrizarlas desde variables de ambiente o usando alguna estrategia como
> las mencionadas arriba

Un ejemplo de agregar una personalización sería:

```
FROM siutoba/php:web-7.4

COPY ./custom.ini /etc/php7/conf.d/99-custom.ini
```
