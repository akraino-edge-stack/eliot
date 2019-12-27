# stage 1
FROM node:current-slim as node
WORKDIR /usr/src/app
COPY package.json .

RUN npm install

COPY . .
RUN npm run build --prod

EXPOSE 4200
CMD [ "npm", "start" ]
#COPY . .
#RUN npm run build --prod

# stage 2
#FROM nginx:alpine
#COPY --from=node /app/dist/eliotportal /usr/share/nginx/html