# frozen_string_literal: true
# _plugins/wiki_element.rb
# Only replaces <wiki>…</wiki> substrings; does NOT reserialize the whole page.
require 'nokogiri'
require 'uri'

WIKI_RE = /<wiki\b[^>]*>.*?<\/wiki>/mi

Jekyll::Hooks.register [:documents, :pages], :post_render do |doc|
  out = doc.output
  next unless doc.output_ext == '.html' && out&.include?('<wiki')

  default_lang = (doc.site.config.dig('wiki', 'default_lang') || 'fr').to_s
  page_lang    = (doc.data['wiki_lang'] || nil)&.to_s

  doc.output = out.gsub(WIKI_RE) do |match|
    # Parse just the matched fragment
    frag = Nokogiri::HTML5.fragment(match)  # HTML5 parser minimizes weirdness
    node = frag.at_css('wiki')
    # Defensive: if parsing failed, keep original
    next match unless node

    text    = (node.inner_html || '').strip
    site    = node['site']&.strip || 'wikipedia'
    page    = node['page']&.strip || text
    section = node['section']&.strip
    lang    = node['lang']&.strip || page_lang || default_lang

    # If still nothing to link, keep original
    next match if (page.nil? || page.empty?)

    href = begin
      slug = URI.encode_www_form_component(page.sub(/\A./, &:upcase).tr(' ', '_'))
      sect = section && !section.empty? ? "##{URI.encode_www_form_component(section.tr(' ', '_'))}" : ''
      "https://#{lang}.#{site}.org/wiki/#{slug}#{sect}"
    end

    label = text.empty? ? (page || query) : text
    icon  = (node['icon'] == 'false') ? '' : %(<i class="fab fa-wikipedia-w"></i> )

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