module Merb
  module GlobalHelpers
    def link_to_couchdb(profile)
      CURRENT_SOURCE / "_utils/browse/document.html?" + COUCHDB / profile.id
    end

    def link_to_get_profile(profile)
      CURRENT_SOURCE / COUCHDB / profile.id
    end

    def link_to_post_profile
      CURRENT_SOURCE / COUCHDB
    end
    
    def link_to_all_posts
      CURRENT_SOURCE / COUCHDB / '_all_docs'
    end

    def link_to_replicate
      CURRENT_SOURCE / '_replicate'
    end
  end
end
