class SchoolClass {
  final int classId;
  final String className;

  const SchoolClass({
    required this.classId,
    required this.className,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'classId': int id,
        'className': String className,
      } =>
        SchoolClass(
          classId: id,
          className: className,
        ),
      _ => throw const FormatException('Klasse kunne ikke findes.'),
    };
  }

  static List<SchoolClass> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => SchoolClass.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
