FROM ghcr.io/cirruslabs/flutter:3.29.0 AS build

WORKDIR /app

COPY . .

RUN flutter config --enable-web && \
    flutter pub get && \
    flutter build web --release

FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
