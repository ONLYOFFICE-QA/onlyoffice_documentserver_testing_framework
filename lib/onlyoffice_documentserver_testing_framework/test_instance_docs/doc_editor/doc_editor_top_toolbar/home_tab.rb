# frozen_string_literal: true

require_relative 'home_tab/editor_tab'

module OnlyofficeDocumentserverTestingFramework
  # Class for Home tab actions
  # https://user-images.githubusercontent.com/668524/28775382-4b8609d0-75fa-11e7-8bfd-a2de8e8a1332.png
  class HomeTab < EditorTab
    def initialize(instance, tab_xpath: '//a[@data-tab="home"]/..', tab_name: 'Home')
      super
      @instance = instance
      @xpath_insert_tab = tab_xpath
      @tab_name = tab_name
    end
  end
end
