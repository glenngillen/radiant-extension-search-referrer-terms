module ReferrerTermsTags
  include Radiant::Taggable

  class TagError < StandardError; end
  
  desc %{ 
    Renders the containing elements only if the request has been referred
    from a search engine

    *Usage:*
    <pre><code><r:if_has_referrer_terms>...</r:if_has_referrer_terms></code></pre>
  }
  tag "if_has_referrer_terms" do |tag|
    if referring_terms
      tag.expand
    end
  end
  
  desc %{ 
    Outputs the referring keywords from the search engine query

    *Usage:*
    <pre><code><r:referrer_terms></code></pre>
  }
  tag "referrer_terms" do |tag|
    referring_terms
  end
  
  private
  def referrer
    @referrer ||= @request.env["HTTP_REFERER"]
  end
  
  def search_referrers
    [
      [/^http:\/\/(www\.)?google.*/, 'q'],
      [/^http:\/\/search\.yahoo.*/, 'p'],
      [/^http:\/\/search\.msn.*/, 'q'],
      [/^http:\/\/search\.aol.*/, 'userQuery'],
      [/^http:\/\/(www\.)?altavista.*/, 'q'],
      [/^http:\/\/(www\.)?feedster.*/, 'q'],
      [/^http:\/\/search\.lycos.*/, 'query'],
      [/^http:\/\/(www\.)?alltheweb.*/, 'q']
    ]
  end
  
  def query_args
    query_args ||= 
      begin
        URI.split(referrer)[7]
      rescue URI::InvalidURIError
        nil
      end
  end
  
  def stop_words
    /\b(\d+|\w|about|after|also|an|and|are|as|at|be|because|before|between|but|by|can|com|de|do|en|for|from|has|how|however|htm|html|if|i|in|into|is|it|la|no|of|on|or|other|out|since|site|such|than|that|the|there|these|this|those|to|under|upon|vs|was|what|when|where|whether|which|who|will|with|within|without|www|you|your)\b/i
  end
  
  def find_referring_terms(remove_stop_words)
    return @referring_terms unless @referring_terms.nil?
    unless referrer.nil? || referrer.empty?  
      search_referrers.each do |reg, query_param_name|
        if (reg.match(referrer))
          unless query_args.nil? || query_args.empty?
            query_args.split("&").each do |arg|
              pieces = arg.split('=')
              if pieces.length == 2 && pieces.first == query_param_name
                unstopped_keywords = CGI.unescape(pieces.last)
                @referring_terms = unstopped_keywords
                @referring_terms.gsub!(stop_words, '') if remove_stop_words
                return @referring_terms.squeeze(' ')
              end
            end
          end
        end
      end
    end
    @referring_terms = false
  end
  
  def referring_terms(remove_stop_words = false)
    find_referring_terms(remove_stop_words)
  end

end