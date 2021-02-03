# frozen_string_literal: true

module OnlyofficeDocumentserverTestingFramework
  # Class for working with DocumentServer version
  class DocumentServerVersion
    include Comparable

    # @return [Integer] Major version
    attr_reader :major
    # @return [Integer] Minor version
    attr_reader :minor
    # @return [Integer] Patch version
    attr_reader :patch
    # @return [Integer] Build version
    attr_reader :build

    # rubocop:disable Metrics/ParameterLists
    def initialize(major = 0, minor = 0, patch = 0, build = 0)
      @major = major
      @minor = minor
      @patch = patch
      @build = build
    end
    # rubocop:enable Metrics/ParameterLists

    # @param string [String] string value of build to parse
    # @return [DocumentServerVersion] result of parsing
    def parse(string)
      return self if string == 'Unknown'

      split_by_dot = string.split('.')
      split_by_space = split_by_dot[2].split
      @major = split_by_dot[0].to_i
      @minor = split_by_dot[1].to_i
      @patch = split_by_space[0].to_i
      @build = split_by_space[1].scan(/\d/).join.to_i
      self
    end

    # @return [String] string value
    def to_s
      "#{@major}.#{@minor}.#{@patch} (build:#{@build})"
    end

    # @return [String] sting with all digits separted by dots
    def to_dotted_string
      "#{@major}.#{@minor}.#{@patch}.#{@build}"
    end

    # Compare two DocumentServerVersion
    # @param [DocumentServerVersion] other to compare
    # @return [Integer] result of compare
    def <=>(other)
      Gem::Version.new(to_dotted_string) <=>
        Gem::Version.new(other.to_dotted_string)
    end
  end
end
