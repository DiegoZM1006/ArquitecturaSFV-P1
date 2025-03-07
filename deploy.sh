#!/bin/bash

# Verificamos si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "Error: Docker no está instalado. Instálalo y vuelve a intentarlo."
    exit 1
fi

echo "Docker está instalado. Continuando..."

# Definimos las variables
time_stamp=$(date +%Y%m%d%H%M%S)
image_name="node_app:$time_stamp"
container_name="node_app_container"

# Construimos la imagen de Docker
echo "Construyendo la imagen de Docker..."
docker build -t $image_name .
if [ $? -ne 0 ]; then
    echo "Error: Fallo en la construcción de la imagen."
    exit 1
fi

echo "Imagen construida correctamente: $image_name"

# Ejecutamos el contenedor
echo "Ejecutando el contenedor..."
docker run -d --name $container_name -p 8080:8080 -e PORT=8080 -e NODE_ENV=production $image_name
if [ $? -ne 0 ]; then
    echo "Error: Fallo al iniciar el contenedor."
    exit 1
fi

echo "Contenedor ejecutándose como $container_name"

# Esperamos unos segundos para que la app arranque
sleep 5

# Verificamos si el servicio responde
echo "Verificando si la aplicación responde..."
curl -I http://localhost:8080
if [ $? -ne 0 ]; then
    echo "Error: La aplicación no respondió correctamente."
    exit 1
fi

echo "Aplicación funcionando correctamente en http://localhost:8080"

# Resumen del proceso
echo "--------------------------"
echo "Resumen de la ejecución:"
echo "Imagen creada: $image_name"
echo "Contenedor en ejecución: $container_name"
echo "URL de acceso: http://localhost:8080"
echo "--------------------------"

exit 0