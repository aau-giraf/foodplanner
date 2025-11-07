class Child {
  final int childId;
  final String firstName;
  final String lastName;
  final int classId;

  const Child({
    required this.childId,
    required this.firstName,
    required this.lastName,
    required this.classId,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'childId': int childId,
        'firstName': String firstName,
        'lastName': String lastName,
        'classId': int classId,
      } =>
        Child(
          childId: childId,
          firstName: firstName,
          lastName: lastName,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }
}
