FROM nginx:alpine

# Copy custom nginx config
COPY web.conf /etc/nginx/conf.d/

# Copy static files
COPY index.html /usr/share/nginx/html/
COPY error.html /usr/share/nginx/html/
COPY team.jpg /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
