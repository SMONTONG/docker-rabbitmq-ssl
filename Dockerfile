# Use an image of RabbitMQ with the management plugin pre-installed
FROM rabbitmq:3-management-alpine AS rabbitmq-server

# Set the author of the Dockerfile
LABEL maintainer="Sonnarin MONTONG <contact@sonnarinmontong.fr>"

ENV RABBITMQ_USER=${RABBITMQ_USER}:user
ENV RABBITMQ_PASSWORD=${RABBITMQ_PASSWORD}:user
ENV RABBITMQ_PID_FILE /var/lib/rabbitmq/mnesia/rabbitmq

# Update the packages in Alpine Linux
RUN apk update && apk upgrade

# Install tls-gen
RUN apk add --no-cache openssl git python3 make && ln -sf python3 /usr/bin/python
RUN git clone https://github.com/rabbitmq/tls-gen tls-gen
RUN cd tls-gen/basic  \
    && make PASSWORD= CN=localhost \
    && make verify \
    && make info \
    && ls -l ./result

RUN mkdir /certificates
RUN mv /tls-gen/basic/result/ca_certificate.pem /certificates/ca.pem

RUN find /tls-gen/basic/result -name 'client*certi*.pem' -exec bash -c 'mv $0 /certificates/client_certificate.pem' {} \;
RUN find /tls-gen/basic/result -name 'client*key*.pem' -exec bash -c 'mv $0 /certificates/client_key.pem' {} \;
RUN find /tls-gen/basic/result -name 'server*certi*.pem' -exec bash -c 'mv $0 /certificates/server_certificate.pem' {} \;
RUN find /tls-gen/basic/result -name 'server*key*.pem' -exec bash -c 'mv $0 /certificates/server_key.pem' {} \;

# Configure RabbitMQ management plugin to use SSL
RUN rabbitmq-plugins enable rabbitmq_federation && rabbitmq-plugins enable rabbitmq_federation_management
COPY docker/rabbitmq/rabbitmq.conf /etc/rabbitmq/rabbitmq.conf

COPY docker/rabbitmq/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["rabbitmq-server"]

# Expose the ports used by the RabbitMQ management plugin with SSL
EXPOSE 5671 5672 15672
