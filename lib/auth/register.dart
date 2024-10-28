import 'package:alertabq/auth/auth_service.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  bool isPasswordVisible = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = AuthService();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              Text(
                '¡Bienvenid@!',
                style: TextStyle(
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_circle),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                  onPressed: _registerWithEmailAndPassword,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                    ),
                    textStyle: TextStyle(fontSize: size.width * 0.045),
                  ),
                  child: const Text('Registrarse',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'O',
                style: TextStyle(
                    fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),
              ElevatedButton(
                  onPressed: _signInWithGoogle,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.g_mobiledata),
                      SizedBox(width: size.width * 0.02),
                      const Text(
                        'Registrarse con Google',
                      ),
                    ],
                  )),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/Login');
                },
                child: Text(
                  '¿Ya tienes una cuenta? Iniciar sesión',
                  style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerWithEmailAndPassword() async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        _emailController.text, _passwordController.text);
    if (result.success && mounted) {
      Navigator.pop(context);
    } else {
      _showErrorSnackBar(result.error);
    }
  }

  void _signInWithGoogle() async {
    AuthResult result = await _auth.loginWithGoogle();
    if (result.success && mounted) {
      Navigator.pop(context);
    } else {
      _showErrorSnackBar(result.error);
    }
  }

  void _showErrorSnackBar(String? code) {
    String message;
    switch (code) {
      case 'email-already-in-use':
        message = 'El correo ya está en uso';
        break;
      case 'weak-password':
        message = 'Contraseña débil';
        break;
      default:
        message = 'Error desconocido';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
