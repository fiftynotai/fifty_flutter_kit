#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fifty_map_engine.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fifty_map_engine'
  s.version          = '0.1.0'
  s.summary          = 'Fifty Flutter Kit map engine - Flame-based interactive grid map rendering for Flutter games'
  s.description      = <<-DESC
Fifty Flutter Kit map engine - Flame-based interactive grid map rendering for Flutter games.
Provides tile-based map rendering with pan, zoom, and entity management.
                       DESC
  s.homepage         = 'https://github.com/fiftynotai/fifty_flutter_kit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Fifty.ai' => 'dev@fifty.ai' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
