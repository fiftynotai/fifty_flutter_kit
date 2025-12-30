//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <fifty_map_engine/fifty_map_engine_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) fifty_map_engine_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FiftyMapEnginePlugin");
  fifty_map_engine_plugin_register_with_registrar(fifty_map_engine_registrar);
}
