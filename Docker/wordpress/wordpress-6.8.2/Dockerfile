FROM almalinux as build
RUN mkdir /home/word

WORKDIR /home/word

COPY . .

FROM nginx
COPY --from=build /usr/share/nginx/html .

