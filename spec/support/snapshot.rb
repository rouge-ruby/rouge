# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'fileutils'

module Support
  module Snapshot
    def assert_snapshot(actual, file_name)
      expected = load_snapshot(file_name)
      if update_snapshots? || expected.nil?
        take_snapshot(actual, file_name)
        assert true
      else
        assert_equal expected, actual
      end
    end

    private

    def load_snapshot(file_name)
      File.read(snapshot_path(file_name))
    rescue Errno::ENOENT
      nil
    end

    def take_snapshot(data, file_name)
      path = snapshot_path(file_name)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |file|
        file.write(data)
      end
    end

    def update_snapshots?
      ENV.has_key?('UPDATE_SNAPSHOTS')
    end

    def snapshot_path(file_name)
      File.join(File.dirname(__FILE__), '..', '__snapshots__', "#{file_name}.snap")
    end
  end
end
