class Pupil {
  final int pupilId;
  final String firstName;
  final String lastName;
  final int? guardianId; //eksistere ikke længere i databasen - sker i et table.
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
}
