class Profile < CouchRest::Model
  use_database CouchRest.database!('http://localhost:5984/profiles-test')

  key_reader :slug, :created_at, :updated_at
  timestamps!

  key_accessor :name

end
