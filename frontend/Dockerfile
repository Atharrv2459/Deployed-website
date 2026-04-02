FROM nginx:alpine

# Copy static files to nginx html directory
COPY . /usr/share/nginx/html

# Copy nginx config as template
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Remove unnecessary files from html directory
RUN rm -f /usr/share/nginx/html/nginx.conf /usr/share/nginx/html/docker-entrypoint.sh /usr/share/nginx/html/Dockerfile /usr/share/nginx/html/.dockerignore

# Default backend URL (override with Railway env var)
ENV BACKEND_URL=http://backend:5000
ENV PORT=80

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
