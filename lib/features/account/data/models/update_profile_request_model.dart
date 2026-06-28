class UpdateProfileRequestModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;

  const UpdateProfileRequestModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth,
    };
  }
}
