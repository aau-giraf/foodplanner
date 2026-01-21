class Pupil {
  final int pupilId;
  final String firstName;
  final String lastName;
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
        'childId': int pupilId,
        'firstName': String firstName,
        'lastName': String lastName,
        'parentId': int guardianId,
        'classId': int classId,
      } =>
        Pupil(
          pupilId: pupilId,
          firstName: firstName,
          lastName: lastName,
          guardianId: guardianId,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }

  // added model for responses without parentID
  factory Pupil.fromChildJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'childId': int childId,
        'firstName': String firstName,
        'lastName': String lastName,
        'classId': int classId,
      } =>
        Pupil(
          pupilId: childId,
          firstName: firstName,
          lastName: lastName,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    }; 
  }
}
