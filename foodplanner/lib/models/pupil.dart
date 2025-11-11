class Pupil {
  final int childId;
  final String firstName;
  final String lastName;
  final int parentId;
  final int classId;

  const Pupil({
    required this.childId,
    required this.firstName,
    required this.lastName,
    required this.parentId,
    required this.classId,
  });

  factory Pupil.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'childId': int childId,
        'firstName': String firstName,
        'lastName': String lastName,
        'parentId': int parentId,
        'classId': int classId,
      } =>
        Pupil(
          childId: childId,
          firstName: firstName,
          lastName: lastName,
          parentId: parentId,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }
}
