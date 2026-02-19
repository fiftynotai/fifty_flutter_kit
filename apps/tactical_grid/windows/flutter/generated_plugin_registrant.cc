//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <fifty_audio_engine/fifty_audio_engine_plugin_c_api.h>
#include <fifty_world_engine/fifty_world_engine_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  FiftyAudioEnginePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FiftyAudioEnginePluginCApi"));
  FiftyWorldEnginePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FiftyWorldEnginePluginCApi"));
}
