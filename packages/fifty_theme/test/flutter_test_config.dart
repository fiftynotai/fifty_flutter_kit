import 'dart:async';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // google_fonts v8 rethrows font-loading exceptions in test environments.
  // Leave allowRuntimeFetching at its default (true) so google_fonts does not
  // throw a hard exception when fonts are not bundled as assets. The HTTP
  // fetch will fail silently in tests -- the pending font futures must still
  // be drained by each test that triggers font loading.
  await testMain();
}
