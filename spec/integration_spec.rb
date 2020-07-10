# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Koine::Filesystem::Adapters::Sftp' do
  subject(:ftp) do
    Koine::Filesystem::Adapters::Sftp.new(
      username: 'ftpuser',
      password: 'ftppassword',
      port: 2222
    )
  end

  let(:files_to_create) do
    [
      'tmp/one.txt',
      'tmp/two.txt',
      'tmp/three/four.txt',
      'tmp/three/five/six.txt',
      'tmp/three/five/seven.txt'
    ]
  end

  before do
    if ENV['CI']
      skip 'sftp is not setup'
    end

    files_to_create.each do |file|
      FileUtils.mkdir_p(File.dirname(file))
      FileUtils.touch(file)
    end
  end

  describe '#list' do
    describe 'when not recursive' do
      it 'lists all files in root folder' do
        files = only_key(:path, ftp.list).sort

        expect(files).to eq([
          'one.txt',
          'two.txt',
          'three'
        ].sort)
      end

      it 'lists all files from subfolder' do
        files = only_key(:path, ftp.list('three')).sort

        expect(files).to eq([
          'three/four.txt',
          'three/five'
        ].sort)
      end

      it 'lists all files from subfolder ignoring slashes' do
        files = only_key(:path, ftp.list('./three/')).sort

        expect(files).to eq([
          'three/four.txt',
          'three/five'
        ].sort)
      end
    end

    describe 'when is recursive' do
      it 'lists all files recursively' do
        files = only_key(:path, ftp.list(recursive: true)).sort

        expect(files).to eq([
          'one.txt',
          'two.txt',
          'three/four.txt',
          'three/five/six.txt',
          'three/five/seven.txt',
          'three',
          'three/five'
        ].sort)
      end

      it 'lists all files recursively ignoring slashes' do
        files = only_key(:path, ftp.list('/three/', recursive: true)).sort

        expect(files).to eq([
          'three/four.txt',
          'three/five/six.txt',
          'three/five/seven.txt',
          'three/five'
        ].sort)
      end

      it 'lists all files recursively from a folder' do
        files = only_key(:path, ftp.list('three', recursive: true)).sort

        expect(files).to eq([
          'three/four.txt',
          'three/five/six.txt',
          'three/five/seven.txt',
          'three/five'
        ].sort)
      end
    end

    it 'maps file type' do
      files = ftp.list(recursive: true)

      expect(map_files(:type, files)).to eq(
        'one.txt' => 'file',
        'two.txt' => 'file',
        'three/four.txt' => 'file',
        'three/five/six.txt' => 'file',
        'three/five/seven.txt' => 'file',
        'three' => 'dir',
        'three/five' => 'dir'
      )
    end

    it 'maps file extension' do
      files = ftp.list(recursive: true)

      expect(map_files(:extension, files)).to eq(
        'one.txt' => 'txt',
        'two.txt' => 'txt',
        'three/four.txt' => 'txt',
        'three/five/six.txt' => 'txt',
        'three/five/seven.txt' => 'txt',
        'three' => nil,
        'three/five' => nil
      )
    end

    it 'maps file dirname' do
      files = ftp.list(recursive: true)

      expect(map_files(:dirname, files)).to eq(
        'one.txt' => '',
        'two.txt' => '',
        'three/four.txt' => 'three',
        'three/five/six.txt' => 'three/five',
        'three/five/seven.txt' => 'three/five',
        'three' => '',
        'three/five' => 'three'
      )
    end

    it 'maps file size' do
      files = ftp.list(recursive: true)

      expect(map_files(:size, files)).to eq(
        'one.txt' => 0,
        'two.txt' => 0,
        'three/four.txt' => 0,
        'three/five/six.txt' => 0,
        'three/five/seven.txt' => 0,
        'three' => 4096,
        'three/five' => 4096
      )
    end

    it 'maps file timestamp' do
      files = ftp.list(recursive: true)

      map_files(:timestamp, files).each do |_key, value|
        expect(value).to be_a(Time)
      end
    end
  end
end
