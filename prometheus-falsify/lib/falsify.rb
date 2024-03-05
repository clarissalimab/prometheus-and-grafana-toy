require "logger"
require "./lib/false_metrics_parser"
require "./lib/metrics"

class Falsify
  def self.call
    file_path = ENV.fetch("FAKE_METRICS_FILE_PATH", "./fake_metrics.yml")

    sequences = FalseMetricsParser.call(file_path)

    execute_sequences(sequences)
  end

  private

  def self.execute_sequences(sequences)
    sequences.each do |sequence|
      metric = Metrics.new(sequence[:name], sequence[:type], sequence[:help])
      sequence[:data].each do |data|
        data[:times].times do
          metric.observe(data[:value], data[:labels])
          sleep(data[:interval])
        end
      end
    end
  end
end
