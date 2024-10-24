import 'package:alertabq/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int drawerIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      drawerIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/Home');
        break;
      case 1:
        break;
      case 2:
        Navigator.popUntil(context, ModalRoute.withName('/'));
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color textColor =
        isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF2D3748);
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Configurar cuenta', style: TextStyle(fontSize: 20.0)),
      ),
      drawer: CustomDrawer(
          isDarkMode: isDarkMode,
          textColor: textColor,
          selectedIndex: drawerIndex,
          onItemTapped: _onItemTapped),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Foto de perfil
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/images/landing.svg'), // Imagen de perfil por defecto
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () {
                        // Lógica para cambiar la foto de perfil
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Campo para cambiar el nombre
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Campo para cambiar el correo
            const TextField(
              decoration: InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Campo para cambiar la contraseña
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Botón para guardar los cambios
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar los cambios
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
