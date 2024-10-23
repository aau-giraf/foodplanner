class Child {
  final int id;
  final String firstName;
  final String lastName;
  final int parentId;
  final int classId;

  const Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.parentId,
    required this.classId,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'first_name': String firstName,
        'last_name': String lastName,
        'parent_id': int parentId,
        'class_id': int classId,
      } =>
        Child(
          id: id,
          firstName: firstName,
          lastName: lastName,
          parentId: parentId,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }
}
