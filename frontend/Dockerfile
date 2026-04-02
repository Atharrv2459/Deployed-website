FROM nginx:alpine

# Copy static files to nginx html directory
COPY . /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Remove unnecessary files from html directory
RUN rm -f /usr/share/nginx/html/nginx.conf /usr/share/nginx/html/docker-entrypoint.sh /usr/share/nginx/html/Dockerfile /usr/share/nginx/html/.dockerignore

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
