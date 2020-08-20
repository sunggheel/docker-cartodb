docker-cartodb
==============

This repo contanis the Dockerfile that can build a fresh image with the latest version of the master branches of the [CartoDB GitHub repositories](https://github.com/CartoDB).

How to build the image:
-----------------------

The image can be build with
```
git clone https://github.com/sunggheel/docker-cartodb.git
docker build -t=my_cartodb docker-cartodb/
```

How to run the container:
-------------------------

```
docker run -d -p 80:80 -h cartodb.localhost my_cartodb
```

The CartoDB instance has been configured with the hostname `cartodb.localhost`, this means the web browser and web server need to be able to resolve `cartodb.localhost` to an IP adress of the machine where the web server is running.
This can be done by adding cartodb.localhost alias to your hosts file. For example
```
sudo sh -c 'echo 127.0.1.1 cartodb.localhost >> /etc/hosts'
```
(For Windows it will be `C:\Windows\System32\drivers\etc\hosts`)

Just run the commands and then connect to http://cartodb.localhost with your browser.

The default login is dev/pass1234. You may want to change it when you run it for the outside.

It also creates an 'example' organization with owner login admin4example/pass1234.
Organization members can be created on http://cartodb.localhost/user/admin4example/organization


How to use a different hostname:
--------------------------------

For example to use `cartodb.example.com` as a hostname start with:
```
docker run -d -p 80:80 -h cartodb.example.com my_cartodb
```

The chosen hostname should also resolve to an IP adress of the machine where the web server is running.

If you don't have a domain/subdomain pointing to your server yet, you can use the servers external ip address:
```
docker run -d -p 80:80 -h <servers-external-ip-address> my_cartodb
```

Instead of setting hostname with `-h` you can also use the `CARTO_HOSTNAME` environment variable with:
```
docker run -d -p 80:80 -e CARTO_HOSTNAME=<hostname> my_cartodb
```

Persistent data
---------------

To persist the PostgreSQL data, the PostGreSQL data dir (/var/lib/postgresql) must be persisted outside the Cartodb Docker container.

The PostgreSQL data dir is filled during the building of this Docker image and must be copied to the local filesystem and then the container must be started with the local copy volume mounted.

```bash
docker create --name cartodb_pgdata my_cartodb
# Change to directory to save the Postgresql data dir (cartodb_pgdata) of the CartoDB image
docker cp cartodb_pgdata:/var/lib/postgresql $PWD/cartodb_pgdata
docker rm -f cartodb_pgdata
```

After this the CartoDB container will have a database that stays filled after restarts.
The CartoDB container can be started with
```
docker run -d -p 80:80 -h cartodb.example.com -v $PWD/cartodb_pgdata:/var/lib/postgresql my_cartodb
```

Geocoder
--------

The external geocoders like heremaps, mapbox, mapzen or tomtom have dummy api keys and do not work.
No attempts have been made or will be made in this Docker image to get the external geocoders to work.

The internal geocoder is configured, but contains no data inside the image.

To fill the internal geocoder run
```
docker exec -ti <carto docker container id> bash -c /cartodb/script/fill_geocoder.sh
```

This will run the scripts described at https://github.com/CartoDB/data-services/tree/master/geocoder
It will use at least 5.7+7.8Gb of diskspace to download the dumps and import them.

