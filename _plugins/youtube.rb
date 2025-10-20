# frozen_string_literal: true
# _plugins/yt_element.rb
# Only replaces <yt>…</yt> substrings; does NOT reserialize the whole page.
require 'nokogiri'
require 'uri'

YT_RE = /<yt\b[^>]*>.*?<\/yt>/mi

Jekyll::Hooks.register [:documents, :pages], :post_render do |doc|
  out = doc.output
  next unless doc.output_ext == '.html' && out&.include?('<yt')

  default_lang = (doc.site.config.dig('yt', 'default_lang') || 'fr').to_s
  page_lang    = (doc.data['yt_lang'] || nil)&.to_s

  doc.output = out.gsub(YT_RE) do |match|
    # Parse just the matched fragment
    frag = Nokogiri::HTML5.fragment(match)  # HTML5 parser minimizes weirdness
    node = frag.at_css('yt')
    # Defensive: if parsing failed, keep original
    next match unless node

    text    = (node.inner_html || '').strip
    video   = node['video']&.strip
    channel = node['channel']&.strip

    # If still nothing to link, keep original
    next match if (video.nil? || video.empty?) && (channel.nil? || channel.empty?)

    href = if (video.nil? || video.empty?)
      "https://www.youtube.com/@#{channel}"
    else
      "https://youtu.be/#{video}"
    end


    label = text.empty? ? (page || query) : text
    icon  = (node['icon'] == 'false') ? '' : %(<i class="fab fa-youtube"></i> )

    # Build just the replacement link string; do not touch the rest of the page
    attrs = []
    attrs << %(href="#{href}")
    attrs << %(rel="#{node['rel'] || 'noopener'}")
    attrs << %(target="#{node['target'] || '_blank'}")
    attrs << %(title="#{node['title']}") if node['title']
    attrs << %(class="#{node['class']}") if node['class']
    attrs << %(id="#{node['id']}")       if node['id']

    %(<a #{attrs.join(' ')}>#{icon}#{label}</a>)
  end
end