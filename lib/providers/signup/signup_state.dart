import 'package:equatable/equatable.dart';

import 'package:fb_auth_provider/models/custom_error.dart';

enum SignupStatus {
  initial,
  submitting,
  success,
  error,
}

class SignupState extends Equatable {
  final SignupStatus signupStatus;
  final CustomError error;
  SignupState({
    required this.signupStatus,
    required this.error,
  });

  factory SignupState.initial() => SignupState(
        signupStatus: SignupStatus.initial,
        error: CustomError(),
      );

  @override
  String toString() =>
      'SignupState(signupStatus: $signupStatus, error: $error)';

  @override
  List<Object> get props => [signupStatus, error];

  SignupState copyWith({
    SignupStatus? signupStatus,
    CustomError? error,
  }) {
    return SignupState(
      signupStatus: signupStatus ?? this.signupStatus,
      error: error ?? this.error,
    );
  }
}
