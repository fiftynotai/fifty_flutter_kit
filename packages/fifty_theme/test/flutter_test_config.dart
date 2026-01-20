import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Disable Google Fonts HTTP requests during tests
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
