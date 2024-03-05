require "logger"
require "prometheus_exporter"
require "prometheus_exporter/client"
require "prometheus_exporter/server"

class Metrics
  def observe(value, labels = {})
    @metric.observe(value, labels)
  end

  def initialize(name, type, help)
    client = PrometheusExporter::Client.default
    @metric = client.register(type, name, help)
  end
end
