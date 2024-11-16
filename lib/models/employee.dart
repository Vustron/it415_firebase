class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  static Employee fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'] as String? ?? 'No ID',
        name: json['name'] as String? ?? 'No Name',
        email: json['email'] as String? ?? 'No Email',
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
      };
}
