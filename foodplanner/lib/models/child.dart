class Child {
  final int childId;
  final String firstName;
  final String lastName;
  //final int parentId;
  final int classId;

  const Child({
    required this.childId,
    required this.firstName,
    required this.lastName,
    //required this.parentId,
    required this.classId,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'childId': int childId,
        'firstName': String firstName,
        'lastName': String lastName,
        //'parentId': int parentId,
        'classId': int classId,
      } =>
        Child(
          childId: childId,
          firstName: firstName,
          lastName: lastName,
          //parentId: parentId,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }
}
