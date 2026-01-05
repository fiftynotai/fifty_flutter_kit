//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_linux/audioplayers_linux_plugin.h>
#include <fifty_audio_engine/fifty_audio_engine_plugin.h>
#include <fifty_map_engine/fifty_map_engine_plugin.h>
#include <fifty_sentences_engine/fifty_sentences_engine_plugin.h>
#include <fifty_speech_engine/fifty_speech_engine_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) audioplayers_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AudioplayersLinuxPlugin");
  audioplayers_linux_plugin_register_with_registrar(audioplayers_linux_registrar);
  g_autoptr(FlPluginRegistrar) fifty_audio_engine_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FiftyAudioEnginePlugin");
  fifty_audio_engine_plugin_register_with_registrar(fifty_audio_engine_registrar);
  g_autoptr(FlPluginRegistrar) fifty_map_engine_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FiftyMapEnginePlugin");
  fifty_map_engine_plugin_register_with_registrar(fifty_map_engine_registrar);
  g_autoptr(FlPluginRegistrar) fifty_sentences_engine_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FiftySentencesEnginePlugin");
  fifty_sentences_engine_plugin_register_with_registrar(fifty_sentences_engine_registrar);
  g_autoptr(FlPluginRegistrar) fifty_speech_engine_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FiftySpeechEnginePlugin");
  fifty_speech_engine_plugin_register_with_registrar(fifty_speech_engine_registrar);
}
