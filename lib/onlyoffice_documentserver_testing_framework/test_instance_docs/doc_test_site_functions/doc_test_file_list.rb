# frozen_string_literal: true

require_relative 'doc_test_file_list/doc_test_site_file_list_entry'
# Class for storing list of test example files
# https://cloud.githubusercontent.com/assets/668524/13947979/935506a6-f02e-11e5-86f4-6903dfd6119e.png
class DocTestFileList
  attr_accessor :file_list

  def initialize(file_list = [])
    @file_list = file_list
  end

  def [](key)
    @file_list[key]
  end

  def -(other)
    diff_items = []
    @file_list.each do |current_item|
      found = false
      other.file_list.each do |other_item|
        found = true if current_item == other_item
      end
      diff_items << current_item unless found
    end
    diff_items
  end
end
