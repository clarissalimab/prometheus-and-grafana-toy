require "spec_helper"
require "./lib/falsify"
require "./lib/false_metrics_parser"
require "./lib/metrics"

RSpec.describe Falsify do
  it "imports metrics" do
    stub_false_metrics_parser
    stub_prometheus

    Falsify.call

    expect(FalseMetricsParser).to have_received(:call).with("./fake_metrics.yml")
  end

  it "executes sequences" do
    stub_false_metrics_parser
    stub_prometheus
    metrics = instance_double(Metrics)
    allow(Metrics).to receive(:new).and_return(metrics)
    allow(metrics).to receive(:observe)

    Falsify.call

    expect(metrics).to have_received(:observe).with(1, { source: "app", service: "web", response_code: "200" })
    expect(metrics).to have_received(:observe).with(1, { source: "app", service: "web", response_code: "400" })
    expect(metrics).to have_received(:observe).with(1, { source: "app", service: "web", response_code: "500" })
  end

  def stub_false_metrics_parser
    allow(FalseMetricsParser).to receive(:call).and_return(
      [
        {
          name: "istio_http_requests_total",
          type: "counter",
          help: "Total number of HTTP requests",
          data: [
            {
              value: 1,
              times: 1,
              interval: 0,
              labels: {
                source: "app",
                service: "web",
                response_code: "200"
              }
            }, {
              value: 1,
              times: 1,
              interval: 0,
              labels: {
                source: "app",
                service: "web",
                response_code: "400"
              }
            }, {
              value: 1,
              times: 1,
              interval: 0,
              labels: {
                source: "app",
                service: "web",
                response_code: "500"
              }
            }
          ]
        }
      ]
    )
  end

  def stub_prometheus
    allow(prometheus).to receive(:send_json)
  end

  def prometheus
    PrometheusExporter::Client.default
  end
end
