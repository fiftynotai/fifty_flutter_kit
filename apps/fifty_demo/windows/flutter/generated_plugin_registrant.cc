//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <fifty_audio_engine/fifty_audio_engine_plugin_c_api.h>
#include <fifty_map_engine/fifty_map_engine_plugin_c_api.h>
#include <fifty_sentences_engine/fifty_sentences_engine_plugin_c_api.h>
#include <flutter_tts/flutter_tts_plugin.h>
#include <speech_to_text_windows/speech_to_text_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  FiftyAudioEnginePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FiftyAudioEnginePluginCApi"));
  FiftyMapEnginePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FiftyMapEnginePluginCApi"));
  FiftySentencesEnginePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FiftySentencesEnginePluginCApi"));
  FlutterTtsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterTtsPlugin"));
  SpeechToTextWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SpeechToTextWindows"));
}
