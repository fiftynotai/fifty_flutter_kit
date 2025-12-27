Pod::Spec.new do |s|
  s.name             = 'fifty_audio_engine'
  s.version          = '0.7.0'
  s.summary          = 'Fifty ecosystem audio engine'
  s.description      = <<-DESC
Modular and reactive audio system for Flutter games and apps.
Part of the Fifty Design Language ecosystem.
                       DESC
  s.homepage         = 'https://github.com/fiftynotai/fifty_eco_system'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Fifty.ai' => 'dev@fifty.ai' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform         = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version    = '5.0'
end
