module Jekyll
  # Generates /series/<key>/ pages, one per _data/series/*.yml file.
  class SeriesPageGenerator < Generator
    safe true
    priority :low

    def generate(site)
      data = site.data['series'] || {}
      data.each do |key, series|
        next unless series.is_a?(Hash) && series['name']
        site.pages << SeriesPage.new(site, site.source, "series/#{key}", key, series)
      end
    end
  end

  class SeriesPage < Page
    def initialize(site, base, dir, key, series)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      @data = {}
      self.process(@name)
      self.data['layout'] = 'series-single'
      self.data['title'] = series['name']
      self.data['series_key'] = key
      self.data['series_name'] = series['name']
      self.data['series_icon'] = series['icon']
    end
  end
end
