import 'package:cerf_mobile/constants/themes.dart';
import 'package:flutter/material.dart';

class VissOptions {
  VissOptions({
    this.theme,
    this.platform,
  });

  final VissTheme theme;
  final TargetPlatform platform;

  VissOptions copyWith({
    VissTheme theme,
    TargetPlatform platform,
  }) {
    return VissOptions(
      theme: theme ?? this.theme,
      platform: platform ?? this.platform,
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType) return false;
    final VissOptions typedOther = other;
    return theme == typedOther.theme && platform == typedOther.platform;
  }

  @override
  int get hashCode => hashValues(
        theme,
        platform,
      );

  @override
  String toString() {
    return '$platform($theme)';
  }
}
