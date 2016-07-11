Pod::Spec.new do |s|

  s.name         = "ALAnimatable"
  s.version      = "0.1"
  s.summary      = "ALAnimatable allows you to animate all subviews in a view at once."
  s.description  = "ALAnimatable adds an Animatable protocol into your project that lets you animate all subviews in a view at once with just a single line of code, providing you have created your user interface using Auto Layout."
  s.homepage     = "https://github.com/almata/ALAnimatable"
  s.screenshots  = "https://raw.githubusercontent.com/almata/ALAnimatable/master/DocAssets/alanimatable-example-1.gif", "https://raw.githubusercontent.com/almata/ALAnimatable/master/DocAssets/alanimatable-example-2.gif", "https://raw.githubusercontent.com/almata/ALAnimatable/master/DocAssets/alanimatable-example-3.gif", "https://raw.githubusercontent.com/almata/ALAnimatable/master/DocAssets/alanimatable-example-4.gif"
  s.license      = "MIT"
  s.author             = { "Albert Mata" => "hello@albertmata.net" }
  s.social_media_url   = "http://twitter.com/almata"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/almata/ALAnimatable.git", :tag => "0.1" }
  s.source_files  = "ALAnimatable", "ALAnimatable/**/*.{h,m,swift}"
end
