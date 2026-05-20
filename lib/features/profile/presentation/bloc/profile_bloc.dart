import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/profile/domain/usecases/get_avatar_path_usecase.dart';
import 'package:shop_flow/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:shop_flow/features/profile/presentation/bloc/profile_event.dart';
import 'package:shop_flow/features/profile/presentation/bloc/profile_state.dart';

/// Loads profile snapshot and avatar path for the profile tab.
@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  /// Wires profile use cases.
  ProfileBloc(
    this._getProfile,
    this._getAvatarPath,
  ) : super(const ProfileInitial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileRefreshRequested>(_onRefresh);
  }

  final GetProfileUseCase _getProfile;
  final GetAvatarPathUseCase _getAvatarPath;

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    await _load(emit);
  }

  Future<void> _onRefresh(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<ProfileState> emit) async {
    final profileResult = await _getProfile.call();
    final avatarResult = await _getAvatarPath.call();

    profileResult.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (user) {
        final avatarPath = avatarResult.fold((_) => null, (path) => path);
        emit(ProfileLoaded(user: user, avatarPath: avatarPath));
      },
    );
  }
}
