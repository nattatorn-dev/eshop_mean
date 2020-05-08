FROM node:13.0.1-alpine as buildContainer
RUN apk update && apk add python make g++
WORKDIR /usr/src/app
COPY ./package.json ./package-lock.json ./
RUN npm install
COPY . /usr/src/app
RUN npm run build:ssr

FROM node:13.0.1-alpine
WORKDIR /usr/src/app
RUN chmod -R 775 /usr/src/app
COPY --from=buildContainer /usr/src/app/package.json /usr/src/app/.env* ./
COPY --from=buildContainer /usr/src/app/dist ./dist

ENTRYPOINT ["npm", "run", "serve:ssr"]
