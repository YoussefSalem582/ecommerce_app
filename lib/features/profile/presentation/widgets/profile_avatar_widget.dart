import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Circular avatar with optional local image path.
class ProfileAvatarWidget extends StatelessWidget {
  /// Creates profile avatar display.
  const ProfileAvatarWidget({
    required this.user,
    this.avatarPath,
    this.radius = 48,
    this.onTap,
    super.key,
  });

  /// Profile entity for initials fallback.
  final UserEntity user;

  /// Optional local image path.
  final String? avatarPath;

  /// Avatar radius.
  final double radius;

  /// Optional tap handler (e.g. change avatar).
  final VoidCallback? onTap;

  String get _initials {
    final first = user.firstName?.trim();
    final last = user.lastName?.trim();
    if (first != null && first.isNotEmpty && last != null && last.isNotEmpty) {
      return '${first.characters.first}${last.characters.first}'.toUpperCase();
    }
    if (user.username.isNotEmpty) {
      return user.username.characters.first.toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    ImageProvider? imageProvider;
    if (avatarPath != null && avatarPath!.isNotEmpty) {
      final file = File(avatarPath!);
      if (file.existsSync()) {
        imageProvider = FileImage(file);
      }
    }

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: palette.primary.withValues(alpha: 0.12),
      foregroundColor: palette.primary,
      backgroundImage: imageProvider,
      child: imageProvider == null ? Text(_initials) : null,
    );

    if (onTap == null) {
      return avatar;
    }

    return GestureDetector(
      onTap: onTap,
      child: avatar,
    );
  }
}
