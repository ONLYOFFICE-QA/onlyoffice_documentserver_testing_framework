# frozen_string_literal: true

require_relative 'doc_editor_top_toolbar/top_toolbar_users'

module OnlyofficeDocumentserverTestingFramework
  # Top Toolbar of Doc Editor
  class DocEditorTopToolbar
    def initialize(instance)
      @instance = instance
    end

    # @return [TopToolbarUsers] icon for top toolbar users
    def users
      @users ||= TopToolbarUsers.new(@instance)
    end
  end
end
