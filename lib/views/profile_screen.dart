import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Usuario',
                  style: TextStyle(fontSize: 20.0, color: textColor)),
              accountEmail: Text('usuario@ejemplo.com',
                  style: TextStyle(fontSize: 20.0, color: textColor)),
              currentAccountPicture: const CircleAvatar(
                child: Text(
                  'U',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              decoration: const BoxDecoration(),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              selected: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurar cuenta'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              selected: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
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
