# Use a base image with ApacheBench installed
FROM debian:latest

# Install ApacheBench
RUN apt-get update && apt-get install -y apache2-utils curl

# Copy the shell script into the container
COPY load-test-ab.sh /load-test-ab.sh

# Make the script executable
RUN chmod +x /load-test-ab.sh

# Run the script
CMD ["/load-test-ab.sh"]
