require_dependency 'application'
class ReferrerTermsExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/referrer_terms"
  
  def activate
    Page.class_eval {
      include ReferrerTermsTags
    }
    # ReferrerTermsTags
  end
  
  def deactivate
  end
  
end