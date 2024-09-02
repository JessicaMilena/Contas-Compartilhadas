import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final List<String> members;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
  });

  // Converte o modelo para um mapa para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': members,
    };
  }

  // Cria um modelo a partir de um documento do Firestore
  factory GroupModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Adicione verificações para garantir que os dados estejam presentes e no formato correto
    return GroupModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      members: List<String>.from(data['members'] ?? []),
    );
  }
}
