class ChildWithClassname {
  final int childId;
  final String firstName;
  final String lastName;
  final String className;
  final int classId;

  const ChildWithClassname({
    required this.childId,
    required this.firstName,
    required this.lastName,
    required this.className,
    required this.classId,
  });

  factory ChildWithClassname.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'childId': int childId,
        'firstName': String firstName,
        'lastName': String lastName,
        'className': String className,
        'classId': int classId,
      } =>
        ChildWithClassname(
          childId: childId,
          firstName: firstName,
          lastName: lastName,
          className: className,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }
}
