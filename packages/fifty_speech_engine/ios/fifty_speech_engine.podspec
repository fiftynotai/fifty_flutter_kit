#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fifty_speech_engine.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fifty_speech_engine'
  s.version          = '0.1.0'
  s.summary          = 'Fifty ecosystem speech engine - TTS and STT for Flutter'
  s.description      = <<-DESC
A unified speech engine providing Text-to-Speech (TTS) and Speech-to-Text (STT)
capabilities for Flutter games and applications. Part of the Fifty Design Language ecosystem.
                       DESC
  s.homepage         = 'https://github.com/fiftynotai/fifty_eco_system'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Fifty.ai' => 'contact@fifty.ai' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'fifty_speech_engine_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
