# frozen_string_literal: true

require 'koine/filesystem'
require 'net/sftp'

module Koine
  module Filesystem
    module Adapters
      VERSION = '1.0.1' # please change koine-filesystem-adapters-sftp.gemspec:5

      class Sftp < Base
        # @param [Hash] options a hash containing the same options as Net::SFTP.start
        #  method plus username and password @see http://net-ssh.github.io/net-sftp/
        #
        # @option options [The Net::SFTP::Session] :session if not given it tries to
        #   create a new one from the options
        # @option options [String] :hostname the ftp hostname
        # @option options [String] :username the ftp hostname
        # @option options [String] :password the ftp password
        def initialize(options)
          if options[:session]
            @session = options.delete(:session)
          else
            @hostname = options.delete(:hostname)
            @username = options.delete(:username)
            @options = options
          end
        end

        def list(path = nil, recursive: false)
          path = format_path(path, '.')
          matcher = format_matcher(recursive)

          entries = []

          session.dir.glob(path, matcher) do |item|
            if item.name == '.' || item.name == '..'
              next
            end

            entries << from_result(item, path)
          end

          entries
        end

        private

        def session
          @session ||= Net::SFTP.start(@hostname, @username, @options)
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
