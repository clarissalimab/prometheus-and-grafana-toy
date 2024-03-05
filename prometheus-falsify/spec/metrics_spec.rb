require "spec_helper"
require "./lib/metrics"

RSpec.describe Metrics do
  it "observes metrics" do
    stub_prometheus

    metric = Metrics.new("istio_http_requests_total", "counter", "Total number of HTTP requests")
    metric.observe(1, { source: "app", service: "web", response_code: "200" })

    expect(prometheus).to have_received(:send_json).with(
        type: "counter",
        help: "Total number of HTTP requests",
        name: "istio_http_requests_total",
        keys: {
          source: "app",
          service: "web",
          response_code: "200"
        },
        value: 1
      )
  end

  def stub_prometheus
    allow(prometheus).to receive(:send_json)
  end

  def prometheus
    PrometheusExporter::Client.default
  end
end
