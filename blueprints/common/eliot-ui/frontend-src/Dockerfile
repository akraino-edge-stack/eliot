# Steps to containerise the ELIOT Portal UI on development mode
FROM node:current-slim as node
WORKDIR /usr/src/app
COPY package.json .

RUN npm cache clean --force
RUN npm install
RUN npm audit fix

COPY . .

RUN npm run build --prod

EXPOSE 4200
CMD [ "npm", "start" ]
#COPY . .
#RUN npm run build --prod
