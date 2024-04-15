class Prediction {
  final int id;
  final String name;
  final String information;
  final List<String> precautions;

  Prediction({
    required this.id,
    required this.name,
    required this.information,
    required this.precautions,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      id: json['id'],
      name: json['name'],
      information: json['information'],
      precautions: List<String>.from(json['precautions']),
    );
  }

  @override
  String toString() {
    return 'Prediction{id: $id, name: $name, information: $information, precautions: $precautions}';
  }
}
