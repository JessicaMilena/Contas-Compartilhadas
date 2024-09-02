import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = _auth.currentUser;

        if (user == null) {
          throw FirebaseAuthException(
              code: 'user-not-authenticated',
              message: 'Usuário não autenticado');
        }

        await _firestore.collection('groups').add({
          'name': _nameController.text,
          'description': _descriptionController.text,
          'creatorId': user.uid,
          'createdAt': Timestamp.now(),
        });

        // Limpa os campos após a criação do grupo
        _nameController.clear();
        _descriptionController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grupo criado com sucesso!')),
        );

        Navigator.pop(context);
      } catch (error) {
        String errorMessage;
        if (error is FirebaseAuthException) {
          errorMessage = error.message ?? 'Erro desconhecido';
        } else {
          errorMessage = 'Erro ao criar grupo: ${error.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Novo Grupo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Grupo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  if (value.length < 3) {
                    return 'O nome do grupo deve ter pelo menos 3 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição (opcional)',
                  hintText: 'Descrição do grupo (máx. 500 caracteres)',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value != null && value.length > 500) {
                    return 'Descrição muito longa (máx. 500 caracteres)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _isLoading ? null : _createGroup,
                      child: Text('Criar Grupo'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
