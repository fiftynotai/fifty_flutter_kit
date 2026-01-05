//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audioplayers_darwin
import fifty_audio_engine
import fifty_map_engine
import fifty_sentences_engine
import flutter_tts
import path_provider_foundation
import speech_to_text

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioplayersDarwinPlugin.register(with: registry.registrar(forPlugin: "AudioplayersDarwinPlugin"))
  FiftyAudioEnginePlugin.register(with: registry.registrar(forPlugin: "FiftyAudioEnginePlugin"))
  FiftyMapEnginePlugin.register(with: registry.registrar(forPlugin: "FiftyMapEnginePlugin"))
  FiftySentencesEnginePlugin.register(with: registry.registrar(forPlugin: "FiftySentencesEnginePlugin"))
  FlutterTtsPlugin.register(with: registry.registrar(forPlugin: "FlutterTtsPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SpeechToTextPlugin.register(with: registry.registrar(forPlugin: "SpeechToTextPlugin"))
}
