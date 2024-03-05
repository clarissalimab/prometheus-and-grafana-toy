require "spec_helper"
require "./lib/false_metrics_parser"

RSpec.describe FalseMetricsParser do
  describe ".call" do
    it "transforms fake metrics file into an array of metrics hashes" do
      file_path = "./spec/support/fake_metrics.yml"

      expect(FalseMetricsParser.call(file_path)).to match(
        [
          {
            name: "istio_http_requests_total",
            type: "counter",
            help: "Total number of HTTP requests",
            data: [
              {
                value: 1,
                times: 5,
                interval: 1,
                labels: {
                  source: "app",
                  service: "web",
                  response_code: "200"
                }
              }, {
                value: 1,
                times: 5,
                interval: 1,
                labels: {
                  source: "app",
                  service: "web",
                  response_code: "400"
                }
              }, {
                value: 1,
                times: 5,
                interval: 1,
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
  end
end
