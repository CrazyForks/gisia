# frozen_string_literal: true

module MethodOverrideGuard
  extend ActiveSupport::Concern

  COUNT = {}

  def method_added(method_name)
    return if prod?

    if ::MethodOverrideGuard::COUNT[method_name] && ::MethodOverrideGuard::COUNT[method_name] != name
      raise "Duplicated method defination: #{method_name}"
    end

    ::MethodOverrideGuard::COUNT[method_name] = name

    super
  end

  def prod?
    @prod ||= Rails.env.production?
  end
end
