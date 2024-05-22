# barebones_setup
A simple start for a Load balancer, Laravel, Vue with docker, independent of external services

Starting a new pet project, I wanted to use vue and laravel but not in the same machine so that later I could change the solution arquitecture, no inner Laravel tools like Sail or Inertia just blades and Breeze, and as few external services as possible.

So lets get cooking.

The backend will initially be a Monolith, the arquitecture will be a load balancer/gateway( actually its just routing traffic, I dont want unnecessary complexity at the start, but later it will change) and a network with all services needed in separate machines that communicate freely (within the network).

I wanted some barebones solution that would fit my requirements but I couldnt find it online, google couldnt help :(

So I ended up developing it, starting with the docker compose file. I want to share it in case someone else is searching for a similar solution and wants to discuss it or wants to build on this.

This is meant as a project starter, so someone can start coding, not prod or anything even close to prod.

My requirements :
- use docker, docker compose and later kubernetes
- infrastructure services, redis, mysql, minio, mailpit.
- keep it simple, no extra tools, no extra complexity
- use laravel in the backend apis
- use laravel blades for the backoffice
- frontend with vue
- clear separation of backend and frontend projects, only api is needed and the frontend can develop without the backend
- booting the project should be clear and simple enough for anyone new or old to development, 
- a docker compose for frontend will be made available and a dev api will allow easily externalized frontend development.
- start with a monolith arquitecture but facilitate the switch to microservices when the basics are working

Everything is in the same internal network, at least for now, if we need to segment networks we will do it later.

I choose nginx for the server in the load balancer as a reverse proxy, php-fpm in laravel, node in the frontend.

The docker images I used, aka ingredients
- node:lts
- redis:alpine
- minio/minio:latest
- axllent/mailpit:latest
- phpmyadmin:5.1
- php:8.3-fpm
- mysql:8.0
- nginx

Then setup some volumes :
- mysql and redis need their volumes so we can restart the system without losing data
- some development folders shared with the host so its easier to develop
- public files shared between the backoffice and the loadbalancer, it will serve some files directly instead of requesting them from the backoffice

Setps to boot up the system :
- composer create-project --prefer-dist laravel/laravel manage
- php artisan install:api
- composer require laravel/breeze --dev
- php artisan breeze:install

- docker ps
- docker exec -it 2abd3b0825ab(monolith id) /bin/bash
-     php artisan migrate
-     php artisan seed

Configure hosts to reflect the chosen url
sudo nano /etc/hosts
127.0.0.1       localhost api.something.com bk.something.com spa.something.com something.com

Now there should be two interesting apps
- something.com, which is the vue frontend.
- bk.something.com is the backoffice in blade.
- api.something.com you can use for the api in laravel
- or can use /api or /bk to setup backoffice and api, theres a nginx rule for it

Future steps :
We will need to manage versioning. Some submodules may help here.
Https needs to be addressed.
Microservice arquitecture, authorization separating logic by api domains.
Setup passport to manage authentication.
Create kubernetes solution.
Volumes need a proper solution.
Implement CICD practices.

The authentication concerns :
- external services using the API
- end-users accessing microservices
- microservices accessing other microservices

Which can be addressed by :
- Edge authorization or, where the authorization can be handled at the gateway
- Service authorization, where the authorization is handled by each service
