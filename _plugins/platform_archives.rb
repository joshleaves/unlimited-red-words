module Jekyll
  # Generates /categories/jeux-vidéo/<platform>/ sub-pages, one per console.
  class PlatformArchiveGenerator < Generator
    safe true
    priority :low

    GAMES_CATEGORY = '🎮 Jeux vidéo'

    def generate(site)
      games = site.posts.docs.select { |p| Array(p.data['categories']).include?(GAMES_CATEGORY) }
      groups = games.group_by { |p| Utils.slugify(p.data.dig('meta', 'platform') || 'Autre') }

      groups.each do |slug, posts|
        title = posts.map { |p| p.data.dig('meta', 'platform') || 'Autre' }
                    .group_by(&:itself)
                    .max_by { |_, v| v.size }
                    .first
        site.pages << PlatformPage.new(site, site.source, "categories/jeux-vidéo/#{slug}", title, posts)
      end
    end
  end

  class PlatformPage < Page
    def initialize(site, base, dir, platform, posts)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      @data = {}
      self.process(@name)
      self.data['layout'] = 'category'
      self.data['title'] = platform
      self.data['platform'] = platform
      self.data['category_title'] = PlatformArchiveGenerator::GAMES_CATEGORY
      self.data['category_url'] = "/categories/#{Utils.slugify(PlatformArchiveGenerator::GAMES_CATEGORY)}/"
      self.data['posts'] = posts.sort_by(&:date).reverse
    end
  end
end
