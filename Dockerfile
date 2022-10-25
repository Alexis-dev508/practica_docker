services:
  db:
    image: mysql:5.7
    ports:
      - "3306:3306"
    command: --default-authentication-plugin=mysql_native_password
    environment:
      #base de datos que utilizaremos 
      MYSQL_DATABASE: laravelPrueba
      #contraseña para root
      MYSQL_ROOT_PASSWORD: 12345
    volumes:
      - ./dump:/docker-entrypoint-initdb.d
      - ./conf:/etc/mysql/conf.d
      - persistent:/var/lib/mysql
    networks:
      - default
  apache:
      build:
        #Indicamos la carpeta donde guardamos el Docker File
        context: ./Dockerfile2
          #Indicamos el archivo dockerfile de este contenedor
        dockerfile: apache_file
      ports: 
          - "80:80"
      volumes:
          #Carpeta donde guardaremos los archivos web : carpeta interna de Docker
          - ./www:/var/www/html
      links:
          #Indicamos con quien va relacionado (servicio de mysql que creamos arriba llamado db)
          - db
      networks:
          - default
      container_name: servidorApache
  phpmyadmin:
    image: phpmyadmin
    container_name: phpmyadmin2
    links: 
        #Indicamos con quien va relacionado
        - db:db
    ports:
        - 90:80
    environment:
        MYSQL_USER: root
        MYSQL_ROOT_PASSWORD:  12345
volumes:
    persistent:
