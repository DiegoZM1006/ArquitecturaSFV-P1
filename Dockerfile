FROM node:18-alpine

WORKDIR /app

COPY package.json ./
RUN npm install --only=production

COPY . .

EXPOSE 8080

ENV PORT=8080
ENV NODE_ENV=production

# Este es el comando que se ejecutará cuando se inicie el contenedor
CMD ["node", "app.js"]
