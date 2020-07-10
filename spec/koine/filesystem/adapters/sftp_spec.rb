# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Koine::Filesystem::Adapters::Sftp do
  subject(:sftp) { described_class.new(options) }

  let(:options) { {} }

  it 'inherits from base' do
    expect(sftp).to be_a(Koine::Filesystem::Adapters::Base)
  end
end
