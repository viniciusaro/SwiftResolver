Pod::Spec.new do |s|
  s.name             = "SwiftResolver"
  s.version          = "1.0.0"
  s.summary          = "Dependency injection framework for Swift."

  s.description      = <<-DESC
                        The dependency injection pattern helps your app split into loosely-coupled components,
                        which can be developed, tested and maintained more easily. SwiftResolver helps you
                        achieve that in an organized way.
                        DESC

  s.homepage         = "https://github.com/99Taxis/SwiftResolver"
  s.license          = 'MIT'
  s.authors          = { "Vinicius Rodrigues" => "vinicius.a.ro@gmail.com" }
  s.source           = { :git => "https://github.com/99Taxis/SwiftResolver.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/aligatr'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.requires_arc = true

  s.source_files = 'Sources/**/*.swift'
end