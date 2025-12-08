class PupilWithClassname {
  final int pupilId;
  final String firstName;
  final String lastName;
  final String className;
  final int classId;

  const PupilWithClassname({
    required this.pupilId,
    required this.firstName,
    required this.lastName,
    required this.className,
    required this.classId,
  });

  factory PupilWithClassname.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'pupilId': int pupilId,
        'firstName': String firstName,
        'lastName': String lastName,
        'className': String className,
        'classId': int classId,
      } =>
        PupilWithClassname(
          pupilId: pupilId,
          firstName: firstName,
          lastName: lastName,
          className: className,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }
}
