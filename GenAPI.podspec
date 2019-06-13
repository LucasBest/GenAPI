Pod::Spec.new do |s|
  s.name             = 'GenAPI'
  s.version          = '0.3.3'
  s.summary          = 'GenAPI is lightweight, Swift, Generics based library for consuming REST APIs.'

  s.description      = <<-DESC
Use GenAPI to easily consume REST API's in a way that takes advantage of Swift Generics.
                       DESC

  s.homepage         = 'https://github.com/LucasBest/GenAPI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lucas Best' => 'lucas.best.5@gmail.com' }
  s.source           = { :git => 'https://github.com/LucasBest/GenAPI.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/thereallu5'

  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'GenAPI/Classes/**/*'

  s.dependency 'ObjectDecoder'
end
