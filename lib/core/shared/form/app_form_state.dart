import 'package:flutter_application_1/core/shared/form/email.dart';
import 'package:flutter_application_1/core/shared/form/password.dart';
import 'package:formz/formz.dart';

class AppFormState with FormzMixin {
  AppFormState(
      {Email? email,
      this.password = const Password.pure(),
      this.status = FormzSubmissionStatus.initial})
      : email = email ?? Email.pure();

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;

  AppFormState copyWith(
      {Email? email, Password? password, FormzSubmissionStatus? status}) {
    return AppFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [email, password];
}
