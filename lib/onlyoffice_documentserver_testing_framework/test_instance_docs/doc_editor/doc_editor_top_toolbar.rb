# frozen_string_literal: true

require_relative 'doc_editor_top_toolbar/top_toolbar_users'
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
  end
end
