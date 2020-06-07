# frozen_string_literal: true

module Rdf2marc
  module Models
    # Model for 1XX: Main Entry Fields.
    class MainEntryFields < Struct
      attribute? :personal_name, General::PersonalName
      attribute? :corporate_name, General::CorporateName
      attribute? :meeting_name, General::MeetingName
    end
  end
end
