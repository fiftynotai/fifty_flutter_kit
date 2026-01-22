Pod::Spec.new do |s|
  s.name             = 'fifty_audio_engine'
  s.version          = '0.7.0'
  s.summary          = 'Fifty Flutter Kit audio engine'
  s.description      = <<-DESC
Modular and reactive audio system for Flutter games and apps.
Part of Fifty Flutter Kit.
                       DESC
  s.homepage         = 'https://github.com/fiftynotai/fifty_flutter_kit'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Fifty.ai' => 'dev@fifty.ai' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version    = '5.0'
end
