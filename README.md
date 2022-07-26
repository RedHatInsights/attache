# Envoy

Simple container providing a kubectl port-forwarding proxy for linking a compose-based local development environment with services running in Kubernetes.

## Usage

Envoy has been designed for use with docker-compose (or podman-compose) to link a set of locally running services with a pod running in Kubernetes. Each remote service should have its own envoy counterpart that is responsible for port-forwarding into the composed environment. First of all, on your local machine, you should be authorized against the target Kubernetes cluster, i.e. `kubectl` should work locally and you should have a `kubeconfig file`. The compose entry requires the following environment variables to be set:

| Variable  | Description                                         | Example value    |
|-----------|-----------------------------------------------------|------------------|
| CLUSTER   | Name of the cluster configured in KUBECONFIG        | foo.bar.baz      |
| USER      | Name of the logged in user                          | user/foo.bar.baz |
| NAMESPACE | Namespace in which the target pod is running        | default          |
| LABELS    | Comma-separated labels that identify the target pod | name=foo,svc=bar |
| PORTS     | Space-separated list of TCP ports to be forwarded   | 1234:1234 5678   |

Example configuration in a compose file linking a database service running in Kubernetes with a locally running application:
```yaml
version: "3"
services:
  db:
    image: quay.io/cloudservices/envoy
    restart: always
    environment:
      - CLUSTER=foo.bar.baz
      - USER=user/foo.bar.baz
      - NAMESPACE=default
      - LABELS=name=app,service=db
      - PORTS=5432
    volumes:
      - ~/.kube/config:/root/.kube/config:Z
    ports:
      - 5432:5432
  app:
    image: your-app-image
    restart: on-failure
    environment:
      - POSTGRESQL_HOST=db
    ports:
      - 3000:3000
    depends_on:
      - db
    links:
      - db
```

## Contributing
If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are warmly welcome.

## License
The application is available as open source under the terms of the [Apache License, version 2.0](https://opensource.org/licenses/Apache-2.0).
