//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_linux/audioplayers_linux_plugin.h>
#include <fifty_audio_engine/fifty_audio_engine_plugin.h>
#include <fifty_world_engine/fifty_world_engine_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) audioplayers_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AudioplayersLinuxPlugin");
  audioplayers_linux_plugin_register_with_registrar(audioplayers_linux_registrar);
  g_autoptr(FlPluginRegistrar) fifty_audio_engine_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FiftyAudioEnginePlugin");
  fifty_audio_engine_plugin_register_with_registrar(fifty_audio_engine_registrar);
  g_autoptr(FlPluginRegistrar) fifty_world_engine_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FiftyWorldEnginePlugin");
  fifty_world_engine_plugin_register_with_registrar(fifty_world_engine_registrar);
}
