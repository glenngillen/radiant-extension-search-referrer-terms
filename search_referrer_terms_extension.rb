require_dependency 'application'
class SearchReferrerTermsExtension < Radiant::Extension
  version "0.1"
  description "Extracts out the search terms entered into google/yahoo/msn/etc that have referred a user to your site "
  url "http://rubypond.com/"
  
  def activate
    Page.class_eval {
      include ReferrerTermsTags
    }
    # ReferrerTermsTags
  end
  
  def deactivate
  end
  
end