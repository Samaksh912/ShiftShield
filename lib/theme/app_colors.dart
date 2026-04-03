import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  // Brand
  final Color primary;
  final Color primaryContainer;
  final Color primarySolid;
  final Color primaryDim;
  final Color onPrimaryFixed;
  
  // Tertiary
  final Color tertiary;
  final Color tertiaryDim;
  
  // Surfaces
  final Color surface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceBright;
  final Color surfaceVariant;
  
  // Typography
  final Color onSurface;
  final Color onSurfaceVariant;
  
  // Feedback
  final Color error;
  final Color secondary;
  
  // Utilities
  final Color outline;
  final Color outlineVariant;

  const AppColors({
    required this.primary,
    required this.primaryContainer,
    required this.primarySolid,
    required this.primaryDim,
    required this.onPrimaryFixed,
    required this.tertiary,
    required this.tertiaryDim,
    required this.surface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceBright,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.error,
    required this.secondary,
    required this.outline,
    required this.outlineVariant,
  });

  factory AppColors.dark() {
    return const AppColors(
      primary: Color(0xFFFF915A),
      primaryContainer: Color(0xFFFF7A31),
      primarySolid: Color(0xFFFF6A00),
      primaryDim: Color(0xFFF76600),
      onPrimaryFixed: Color(0xFF000000),
      tertiary: Color(0xFFFFC96F),
      tertiaryDim: Color(0xFFEFA914),
      surface: Color(0xFF0E0E0E),
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF131313),
      surfaceContainer: Color(0xFF1A1A1A),
      surfaceContainerHigh: Color(0xFF20201F),
      surfaceContainerHighest: Color(0xFF262626),
      surfaceBright: Color(0xFF2C2C2C),
      surfaceVariant: Color(0xFF262626),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFFADAAAA),
      error: Color(0xFFFF7351),
      secondary: Color(0xFFFF923C),
      outline: Color(0xFF767575),
      outlineVariant: Color(0xFF484847),
    );
  }

  factory AppColors.light() {
    return const AppColors(
      primary: Color(0xFFFF6A00), // Kinetic Orange
      primaryContainer: Color(0xFFFF915A), 
      primarySolid: Color(0xFFFF6A00),
      primaryDim: Color(0xFFFF915A),
      onPrimaryFixed: Color(0xFFFFFFFF), // White text on Primary for Light mode
      tertiary: Color(0xFFFFC96F),
      tertiaryDim: Color(0xFFEFA914),
      surface: Color(0xFFF5F5F5), // Soft Cloud Gray
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFEEEEEE), 
      surfaceContainer: Color(0xFFFFFFFF), // Pure White cards
      surfaceContainerHigh: Color(0xFFE0E0E0),
      surfaceContainerHighest: Color(0xFFD6D6D6),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFFE5E5E5),
      onSurface: Color(0xFF0E0E0E), // Jet Black
      onSurfaceVariant: Color(0xFF4A4A4A), // Steel Gray
      error: Color(0xFFFF3D00), // Alert
      secondary: Color(0xFFFF923C),
      outline: Color(0xFFBDBDBD),
      outlineVariant: Color(0xFFE0E0E0),
    );
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryContainer,
    Color? primarySolid,
    Color? primaryDim,
    Color? onPrimaryFixed,
    Color? tertiary,
    Color? tertiaryDim,
    Color? surface,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceBright,
    Color? surfaceVariant,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? error,
    Color? secondary,
    Color? outline,
    Color? outlineVariant,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      primarySolid: primarySolid ?? this.primarySolid,
      primaryDim: primaryDim ?? this.primaryDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      tertiary: tertiary ?? this.tertiary,
      tertiaryDim: tertiaryDim ?? this.tertiaryDim,
      surface: surface ?? this.surface,
      surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest ?? this.surfaceContainerHighest,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      error: error ?? this.error,
      secondary: secondary ?? this.secondary,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      primarySolid: Color.lerp(primarySolid, other.primarySolid, t)!,
      primaryDim: Color.lerp(primaryDim, other.primaryDim, t)!,
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryDim: Color.lerp(tertiaryDim, other.tertiaryDim, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainerLowest: Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow: Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      error: Color.lerp(error, other.error, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
    );
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
