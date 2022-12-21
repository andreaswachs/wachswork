FROM alpine:3.17.0@sha256:4c679bd1e6b6516faf8466986fc2a9f52496e61cada7c29ec746621a954a80ac as base

RUN apk add hugo --no-cache

FROM base as build

WORKDIR /src

COPY src .

RUN hugo -t hugo-winston-theme

FROM nginx:1.23.3@sha256:05e779dde0e9016a61468da02c1e0e5f47afa3927f644913c2d5cfebcdb33e1c as publish

COPY --from=build /src/public/ /usr/share/nginx/html/
