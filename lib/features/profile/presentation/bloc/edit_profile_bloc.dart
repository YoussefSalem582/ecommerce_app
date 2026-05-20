import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/profile/domain/usecases/get_avatar_path_usecase.dart';
import 'package:shop_flow/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:shop_flow/features/profile/domain/usecases/save_avatar_path_usecase.dart';
import 'package:shop_flow/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:shop_flow/features/profile/presentation/bloc/edit_profile_event.dart';
import 'package:shop_flow/features/profile/presentation/bloc/edit_profile_state.dart';

/// Handles edit profile form submission and avatar selection.
@injectable
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  /// Wires profile mutation use cases.
  EditProfileBloc(
    this._getProfile,
    this._updateProfile,
    this._getAvatarPath,
    this._saveAvatarPath,
  ) : super(const EditProfileInitial()) {
    on<EditProfileStarted>(_onStarted);
    on<EditProfileSubmitted>(_onSubmitted);
    on<EditProfileAvatarPicked>(_onAvatarPicked);
  }

  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final GetAvatarPathUseCase _getAvatarPath;
  final SaveAvatarPathUseCase _saveAvatarPath;

  Future<void> _onStarted(
    EditProfileStarted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(const EditProfileLoading());
    final profileResult = await _getProfile.call();
    final avatarResult = await _getAvatarPath.call();

    profileResult.fold(
      (failure) => emit(EditProfileFailure(failure.message)),
      (user) {
        final avatarPath = avatarResult.fold((_) => null, (path) => path);
        emit(EditProfileReady(user: user, avatarPath: avatarPath));
      },
    );
  }

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(const EditProfileLoading());
    final result = await _updateProfile.call(
      email: event.email,
      firstName: event.firstName,
      lastName: event.lastName,
    );
    result.fold(
      (failure) => emit(EditProfileFailure(failure.message)),
      (user) => emit(EditProfileSaved(user)),
    );
  }

  Future<void> _onAvatarPicked(
    EditProfileAvatarPicked event,
    Emitter<EditProfileState> emit,
  ) async {
    final current = state;
    if (current is! EditProfileReady) {
      return;
    }

    final result = await _saveAvatarPath.call(event.path);
    result.fold(
      (failure) => emit(EditProfileFailure(failure.message)),
      (path) => emit(
        EditProfileReady(user: current.user, avatarPath: path),
      ),
    );
  }
}
