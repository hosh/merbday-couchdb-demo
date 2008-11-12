class Profile < CouchRest::Model
  use_database CouchRest.database!('http://localhost:5984/profiles-test')

  class ContactInfo < CouchRest::Model
    key_accessor :phone, :email, :twitter
  end

  class Skill < CouchRest::Model
    key_accessor :skill, :expertise

    key_writer :skilled_since 
    def skilled_since
      Time.parse(self['skilled_since'])
    end

  end


  key_reader :slug, :created_at, :updated_at
  timestamps!

  key_accessor :name, :user_id

  # belongs_to :user
  view_by :user_id, :updated_at
  view_by :user_id

  cast :contact_info, :as => 'Profile::ContactInfo'
  cast :skills, :as => ['Profile::Skill']


  def all_contacts
    self['contact_info'] || ContactInfo.new
  end

end
