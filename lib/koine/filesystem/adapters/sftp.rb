# frozen_string_literal: true

require 'koine/filesystem'

module Koine
  module Filesystem
    module Adapters
      VERSION = '1.0.0' # also change gemspec

      class Sftp < Base
        def initialize(_options)
          @options = {}
        end
      end
    end
  end
end
