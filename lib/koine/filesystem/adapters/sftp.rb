# frozen_string_literal: true

require 'koine/filesystem'
require 'net/sftp'

module Koine
  module Filesystem
    module Adapters
      VERSION = '1.0.0' # also change gemspec

      class Sftp < Base
        def initialize(options)
          @hostname = options.delete(:hostname)
          @username = options.delete(:username)
          @options = options
        end

        def list(path = nil, recursive: false)
          path = format_path(path, '.')
          matcher = format_matcher(recursive)

          entries = []

          ftp.dir.glob(path, matcher) do |item|
            if item.name == '.' || item.name == '..'
              next
            end

            entries << from_result(item, path)
          end

          entries
        end

        private

        def ftp
          @ftp ||= Net::SFTP.start(@hostname, @username, @options)
        end

        # rubocop:disable Metrics/AbcSize
        def from_result(item, dir)
          file_path = "#{dir}/#{item.name}".delete_prefix('.').delete_prefix('/')

          {
            path: file_path,
            type: item.directory? ? 'dir' : 'file',
            extension: item.directory? ? nil : file_path.split('.').last,
            filename: File.basename(file_path),
            dirname: format_path(File.dirname(file_path).delete_prefix('.')),
            timestamp: Time.at(item.attributes.mtime),
            size: item.attributes.size
          }
        end
        # rubocop:enable Metrics/AbcSize

        def format_path(path, default = '')
          path = path.to_s
            .delete_prefix('.')
            .delete_prefix('/')
            .delete_suffix('/')
            .strip

          if path.empty?
            path = default
          end

          path
        end

        def format_matcher(recursive)
          if recursive
            return '**/*'
          end

          '*'
        end
      end
    end
  end
end
