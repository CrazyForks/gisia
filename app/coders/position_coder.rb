class PositionCoder
  def self.dump(position)
    return nil unless position

    if position.is_a?(Gitlab::Diff::Position)
      YAML.dump(position)
    else
      position
    end
  end

  def self.load(yaml_data)
    return nil unless yaml_data

    if yaml_data.is_a?(String)
      begin
        YAML.unsafe_load(yaml_data)
      rescue Psych::SyntaxError, Psych::DisallowedClass
        nil
      end
    else
      yaml_data
    end
  end
end