import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formdata = {};

  // Função para carregar dados do usuário no formulário
  void _loadFormData(User? user) {
    if (user != null) {
      _formdata['id'] = user.id;
      _formdata['name'] = user.name;
      _formdata['email'] = user.email;
      _formdata['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtendo o usuário da rota
    final user = ModalRoute.of(context)?.settings.arguments as User?;

    // Carregar dados do usuário se estiver disponível
    _loadFormData(user);

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Usuario'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              final isValid = _form.currentState?.validate();

              if (isValid ?? false) {
                _form.currentState?.save();

                // Atualiza ou cria o usuário
                Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _formdata['id'] ?? '',
                    name: _formdata['name']!,
                    email: _formdata['email']!,
                    avatarUrl: _formdata['avatarUrl'] ?? '',
                  ),
                );

                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _formdata['name'],
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nome Inválido.";
                  }
                  if (value.trim().length < 3) {
                    return 'Nome muito curto, digite no mínimo 3 letras';
                  }
                  return null;
                },
                onSaved: (value) => _formdata['name'] = value!,
              ),
              TextFormField(
                initialValue: _formdata['email'],
                decoration: InputDecoration(labelText: 'E-Mail'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "E-Mail Inválido.";
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return 'E-Mail inválido.';
                  }
                  return null;
                },
                onSaved: (value) => _formdata['email'] = value!,
              ),
              TextFormField(
                initialValue: _formdata['avatarUrl'],
                decoration: InputDecoration(labelText: 'URL do Seu Avatar'),
                validator: (value) {
                  if (value != null &&
                      value.trim().isNotEmpty &&
                      !Uri.tryParse(value)!.hasAbsolutePath) {
                    return 'URL inválida.';
                  }
                  return null;
                },
                onSaved: (value) => _formdata['avatarUrl'] = value!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
