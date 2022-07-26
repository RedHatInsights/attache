FROM registry.access.redhat.com/ubi9/ubi-minimal as build
WORKDIR /root
ENV STABLE_URL="https://dl.k8s.io/release/stable.txt"
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s $STABLE_URL)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl

FROM registry.access.redhat.com/ubi9/ubi-micro
VOLUME /root/.kube/config
COPY --from=build /root/kubectl /bin/
COPY ./entrypoint.sh /sbin/
CMD ["/sbin/entrypoint.sh"]
