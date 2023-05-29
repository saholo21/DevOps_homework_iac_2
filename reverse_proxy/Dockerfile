# Use the official Nginx base image
FROM nginx:alpine

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 8082

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]