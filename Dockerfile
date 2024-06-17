# Stage 1: Build Stage
FROM alpine:3.20 AS build
WORKDIR /srv/

RUN apk add --no-cache bash git gcc cmake make musl-dev curl-dev

COPY . .

RUN ./scripts/build.sh

# Stage 2: Production Stage
FROM alpine:3.20 AS production
WORKDIR /app/

RUN apk add --no-cache libcurl php83

COPY --from=build /srv/lpac/output/ /app/

CMD ["php", "./rlpa-server.php"]

EXPOSE 1888
