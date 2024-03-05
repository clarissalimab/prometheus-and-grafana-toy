require "logger"
require "yaml"

class FalseMetricsParser
  def self.call(file_path)
    @file_path = file_path

    import
  end

  private

  def self.import
    sequences = YAML.load_file(@file_path)["sequences"]

    sequences.map do |sequence|
      {
        name: sequence["name"],
        type: sequence["type"],
        help: sequence["help"],
        data: sequence["data"].map do |data|
          {
            value: data["value"],
            times: data["times"] || 0,
            interval: data["interval"],
            labels: data["labels"].transform_keys(&:to_sym) || {}
          }
        end
      }
    end
  end
end
