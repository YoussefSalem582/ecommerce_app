---
description: "BLoC and Cubit patterns for ShopFlow"
alwaysApply: false
---

# BLoC & Cubit Patterns

## File layout

- BLoC: `<name>_bloc.dart`, `<name>_event.dart`, `<name>_state.dart`
- Cubit: `<name>_cubit.dart`, `<name>_state.dart` (single file state is OK for small cubits)

## State pattern

```dart
abstract class FeatureState extends Equatable {
  const FeatureState();
  @override
  List<Object?> get props => [];
}

class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  const FeatureLoaded({required this.data});
  final DataType data;
  @override
  List<Object?> get props => [data];
}
class FeatureError extends FeatureState {
  const FeatureError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
```

## BLoC handler

```dart
Future<void> _onLoad(Load event, Emitter<FeatureState> emit) async {
  emit(FeatureLoading());
  final result = await _getFeatureUseCase();
  result.fold(
    (failure) => emit(FeatureError(message: failure.message)),
    (data) => emit(FeatureLoaded(data: data)),
  );
}
```

## UI

- `BlocBuilder` / `BlocListener` / `BlocConsumer`
- `context.read<FeatureBloc>().add(event)`
- Do not call repositories from widgets — use cases only via BLoC

## Logging

Global `TalkerBlocObserver` in `main.dart` logs transitions. **Do not** add `AppLogger` — it does not exist in ShopFlow.

## Offline-aware loads

Follow `ProductListBloc` / `ProductsRepositoryImpl`: repository returns cached Hive data when remote fails; UI shows `OfflineBanner` via `ConnectivityCubit` at app level.
