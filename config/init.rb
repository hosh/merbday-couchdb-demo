# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '75960319d3bc1fd82b861884f698a0fb350ee9ed'  # required for cookie session store
  # c[:session_id_key] = '_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  COUCHDB_SOURCES = [ "http://couchdb1.isshen.net:5984", "http://couchdb2.isshen.net:5984" ]
  CURRENT_SOURCE = COUCHDB_SOURCES[rand(COUCHDB_SOURCES.length)]
  COUCHDB = "profiles-test"
  CURRENT_DB = CURRENT_SOURCE / COUCHDB
  OTHER_DB = (COUCHDB_SOURCES - [ CURRENT_SOURCE ]).first / COUCHDB
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end
