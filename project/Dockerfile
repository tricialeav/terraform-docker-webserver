FROM node:14.14.0-alpine3.10 as builder
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY web_app/package.json ./
RUN yarn install

COPY web_app/ ./
RUN yarn build

FROM nginx:1.19-alpine
COPY --from=builder /app/build /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
EXPOSE 8080