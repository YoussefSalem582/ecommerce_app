import 'package:equatable/equatable.dart';


/// Profile screen events.
sealed class ProfileEvent extends Equatable {
  /// Creates profile event base.
  const ProfileEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads profile + avatar on screen open.
final class ProfileStarted extends ProfileEvent {
  /// Triggers initial load.
  const ProfileStarted();
}

/// Reloads profile after edit or avatar change.
final class ProfileRefreshRequested extends ProfileEvent {
  /// Triggers reload.
  const ProfileRefreshRequested();
}
