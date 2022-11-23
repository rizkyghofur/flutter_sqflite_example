const String tableCatatan = 'notes';

class CatatanFields {
  static final List<String> values = [
    id,
    isImportant,
    number,
    title,
    description,
    time
  ];

  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class Catatan {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Catatan({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Catatan copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Catatan(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static Catatan fromJson(Map<String, Object?> json) => Catatan(
        id: json[CatatanFields.id] as int?,
        isImportant: json[CatatanFields.isImportant] == 1,
        number: json[CatatanFields.number] as int,
        title: json[CatatanFields.title] as String,
        description: json[CatatanFields.description] as String,
        createdTime: DateTime.parse(json[CatatanFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        CatatanFields.id: id,
        CatatanFields.title: title,
        CatatanFields.isImportant: isImportant ? 1 : 0,
        CatatanFields.number: number,
        CatatanFields.description: description,
        CatatanFields.time: createdTime.toIso8601String(),
      };
}
