class ChildRelation {
  final int userId;
  final int childId;

  const ChildRelation({
    required this.userId,
    required this.childId,
  });

  factory ChildRelation.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userId': int userId,
        'childId': int childId,
      } =>
        ChildRelation(
          userId: userId,
          childId: childId,
        ),
      _ => throw const FormatException('Relation kunne ikke findes.'),
    };
  }
}
