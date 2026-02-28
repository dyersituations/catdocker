FROM node:22.12.0-alpine AS build

WORKDIR /app

COPY biddy-spa-src/package*.json ./
RUN npm ci

COPY biddy-spa-src/ ./
RUN npm run build

FROM nginx:alpine

COPY spa.default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
