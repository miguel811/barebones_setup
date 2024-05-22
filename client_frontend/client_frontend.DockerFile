FROM node:lts as build-stage
WORKDIR /app

COPY ./src ./
RUN npm install
RUN npm run dev -- --host &

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]
