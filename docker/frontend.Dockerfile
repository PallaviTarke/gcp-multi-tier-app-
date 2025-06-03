FROM nginx:alpine

COPY app/frontend/index.html /usr/share/nginx/html/index.html
