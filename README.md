# Prometheus and Grafana toy

A toy project to test Prometheus metrics and recording rules in Grafana locally.

It allows you to create fake metrics in Prometheus, record rules and visualize them in Grafana.

## How to run

### Monitoring

```bash
docker compose -f docker-compose.monitoring.yml up --build
```

This will start Prometheus, Grafana and a Prometheus Exporter sidecar.

If you navigate to [http://localhost:3000](http://localhost:3000) you will see Grafana. You should use `admin` as username and `grafana` as password.

### Prometheus Falsify

Prometheus Falsify is a simple Ruby app that parses a set of fake metrics. It's useful to test metrics with Prometheus and Grafana without having to set up a real application.

To populate the fake metrics, run:

```bash
docker compose -f docker-compose.falsify.yml up --build
```

The fake metrics are defined under `prometheus-falsify/fake_metrics.yml`. You can customize metrics following the same structure as the example.

### Recording rules

Recording rules are available under `prometheus/rules/`.

## Coming soon

- Support to run Sloth to generate recording rules for SLOs
