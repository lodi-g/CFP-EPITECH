FROM node:7.10-alpine

ENV NODE_ENV=production

RUN mkdir -p /web
WORKDIR /web

COPY package.json ./
RUN npm install

COPY server.js ./
COPY views/ ./views

CMD [ "node", "server.js" ]
