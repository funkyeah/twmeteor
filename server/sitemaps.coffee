staticSitemap = 
  
  # required: page
  # optional: lastmod, changefreq, priority, xhtmlLinks, images, videos
  [
    {
      page: "/"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "monthly"
    }
    {
      page: "/beers"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "monthly"
    }
    {
      page: "/blog"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "weekly"
    }
    {
      page: "/store"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "monthly"
    }
    {
      page: "/who"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "monthly"
    }
    {
      page: "/where"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "monthly"
    }
    {
      page: "/jobs"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "monthly"
    }
    {
      page: "/taproom_rental"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "monthly"
    }
    {
      page: "/contact"
      lastmod: "2015-01-14T05:36:18+00:00"
      changefreq: "yearly"
    }
  ]

sitemaps.add "/sitemap.xml", ->
  out = []
  blogposts = BlogPosts.find().fetch()
  _.each blogposts, (blog) ->
    out.push
      page: "/blog/" + blog.slug
      changefreq: "never"
  sitemap = staticSitemap.concat(out)
  return sitemap



