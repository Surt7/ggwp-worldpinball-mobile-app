import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/shared/config/security_config.dart';

export 'src/app.dart';

void main() {
  // In debug mode, verify certificates using the local WorldPinball Root CA and handle emulator routing.
  // In release mode (production), the OS natively validates the public TLS certificate.
  if (kDebugMode) {
    final securityContext = SecurityConfig.createSecurityContext();
    HttpOverrides.global = WorldPinballHttpOverrides(securityContext);
  }

  runApp(const MyApp());
}
