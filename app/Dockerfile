FROM node:14.18

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.6.0/wait /wait
RUN chmod +x /wait

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE $APP_PORT

CMD [ "sh", "-c", "/wait && node src/index.js" ]