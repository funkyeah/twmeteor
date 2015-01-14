sitemaps.add "/sitemap.xml", ->
  out = []
  blogposts = BlogPosts.find().fetch()
  _.each blogposts, (blog) ->
    out.push
      page: "/blog/" + blog.slug
  return out


# sitemaps.add "/sitemap.xml", ->
  
#   # required: page
#   # optional: lastmod, changefreq, priority, xhtmlLinks, images, videos
#   [
#     {
#       page: "/"
#       lastmod: "2015-01-14T05:36:18+00:00"
#       changefreq: "monthly"
#     }
#     {
#       page: "/beers"
#       lastmod: "2015-01-14T05:36:18+00:00"
#       changefreq: "monthly"
#     }
#   ]
