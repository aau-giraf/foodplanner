class Pupil {
  final int pupilId;
  final String firstName;
  final String lastName;
  // A child can now have several parents (many-to-many), and the `Children`
  // shape returned by most endpoints no longer carries a parent id, so this is
  // optional. It is only populated by endpoints returning `ChildrenDTO`.
  final int? guardianId;
  final int classId;

  const Pupil({
    required this.pupilId,
    required this.firstName,
    required this.lastName,
    this.guardianId,
    required this.classId,
  });

  factory Pupil.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'childId': final int childId,
        'firstName': final String firstName,
        'lastName': final String lastName,
        'classId': final int classId,
      } =>
        Pupil(
          pupilId: childId,
          firstName: firstName,
          lastName: lastName,
          // `parentId` is present on ChildrenDTO responses but absent on the
          // plain Children entity returned by list/parent endpoints.
          guardianId: json['parentId'] is int ? json['parentId'] as int : null,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }
}
