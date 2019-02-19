import 'package:cerf_mobile/constants/themes.dart';
import 'package:flutter/material.dart';

class VissOptions {
  VissOptions({
    this.theme,
    this.platform,
    this.updateNotes = false,
  });

  final VissTheme theme;
  final TargetPlatform platform;
  final bool updateNotes;

  VissOptions copyWith({
    VissTheme theme,
    TargetPlatform platform,
    bool updateNotes,
  }) {
    return VissOptions(
      theme: theme ?? this.theme,
      platform: platform ?? this.platform,
      updateNotes: updateNotes ?? this.updateNotes,
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
        updateNotes,
      );

  @override
  String toString() {
    return '$platform($theme)';
  }
}
