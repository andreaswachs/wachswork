FROM alpine:3.17.0 as base

RUN apk add hugo --no-cache

FROM base as build

WORKDIR /src

COPY src .

RUN hugo -t hugo-winston-theme

FROM nginx:1.23.3 as publish

COPY --from=build /src/public/ /usr/share/nginx/html/
