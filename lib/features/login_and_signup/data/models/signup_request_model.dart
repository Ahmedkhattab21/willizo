class SignupRequestModel {
final String fullName;
final String email;
final String phoneNumber;
final String dateOfBirth;
final String password;
final String passwordConfirmation;

SignupRequestModel({
  required this.fullName,
  required this.email,
  required this.phoneNumber,
  required this.dateOfBirth,
  required this.password,
  required this.passwordConfirmation,
});

Map<String, dynamic> toJson() => {
  "full_name": fullName,
  "email": email,
  "phone_number": phoneNumber,
  "date_of_birth": dateOfBirth,
  "password": password,
  "password_confirmation": passwordConfirmation,
};

}

