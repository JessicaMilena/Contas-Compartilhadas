import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String groupId = ModalRoute.of(context)!.settings.arguments as String;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> _deleteGroup() async {
      try {
        await _firestore.collection('groups').doc(groupId).delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grupo excluído com sucesso!')),
        );

        Navigator.pop(context); // Navega de volta à tela anterior
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir grupo: ${error.toString()}')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Grupo'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit_group', arguments: groupId);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Confirmar Exclusão'),
                  content:
                      Text('Tem certeza de que deseja excluir este grupo?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _deleteGroup();
                      },
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('groups').doc(groupId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar detalhes do grupo'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Grupo não encontrado'));
          }

          final group = snapshot.data!;
          final name = group['name'];
          final description =
              group['description'] ?? 'Nenhuma descrição fornecida';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: $name',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Descrição: $description', style: TextStyle(fontSize: 16)),
                // Adicione mais detalhes do grupo conforme necessário
              ],
            ),
          );
        },
      ),
    );
  }
}
