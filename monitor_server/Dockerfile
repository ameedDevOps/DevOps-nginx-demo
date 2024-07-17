# Use an official Alpine image as a base
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache bash curl

# Set the working directory
WORKDIR /usr/src/app

# Copy the shell script into the container
COPY check_server_status.sh .

# Make the shell script executable
RUN chmod +x check_server_status.sh

# Run the shell script
CMD ["./check_server_status.sh"]