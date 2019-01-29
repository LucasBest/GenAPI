#
# Be sure to run `pod lib lint GenAPI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GenAPI'
  s.version          = '0.2.3'
  s.summary          = 'GenAPI is lightweight, Swift, Generics based library for consuming REST APIs.'

  s.description      = <<-DESC
Use GenAPI to easily consume REST API's in a way that takes advantage of Swift Generics.
                       DESC

  s.homepage         = 'https://github.com/LucasBest/GenAPI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lucas Best' => 'lucas.best.5@gmail.com' }
  s.source           = { :git => 'https://github.com/LucasBest/GenAPI.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'GenAPI/Classes/**/*'

  s.dependency 'ObjectDecoder'
end
