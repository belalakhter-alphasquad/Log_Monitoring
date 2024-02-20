FROM fluent/fluent-bit:latest

# Add your startup script to the container
COPY startup.sh /startup.sh

# Install nc for the startup script's network check
RUN apt-get update && apt-get install -y netcat && rm -rf /var/lib/apt/lists/*

# Make the startup script executable
RUN chmod +x /startup.sh

# Set the startup script as the new entrypoint
ENTRYPOINT ["/startup.sh"]
