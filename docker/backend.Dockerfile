FROM node:18-alpine

WORKDIR /app
COPY app/backend/ .

RUN npm install

EXPOSE 3000

CMD ["node", "server.js"]
