# frozen_string_literal: true

require_relative 'doc_editor_top_toolbar/home_tab'
require_relative 'doc_editor_top_toolbar/top_toolbar_users'
require_relative 'doc_editor_top_toolbar/top_toolbar_document'
require_relative 'doc_editor_top_toolbar/title_row'

module OnlyofficeDocumentserverTestingFramework
  # Top Toolbar of Doc Editor
  class DocEditorTopToolbar
    def initialize(instance)
      @instance = instance
    end

    # @return [TitleRow] class for methods in title row
    def title_row
      @title_row ||= TitleRow.new(@instance)
    end

    # @return [TopToolbarUsers] icon for top toolbar users
    def users
      @users ||= TopToolbarUsers.new(@instance)
    end

    # @return [TopToolbarDocument] more top toolbar data of document
    def top_toolbar
      @top_toolbar = TopToolbarDocument.new(@instance)
    end

    # @return [HomeTab] home tab
    def home_tab
      @home_tab ||= HomeTab.new(@instance)
    end
  end
end
