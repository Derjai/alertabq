import 'package:alertabq/auth/auth_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  bool isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = AuthService();

  @override
  void dispose() {
    super.dispose();
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
                  '¡Bienvenid@ de vuelta!',
                  style: TextStyle(
                      fontSize: size.width * 0.07, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Ingresar correo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Ingresar contraseña',
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
                      )),
                ),
                SizedBox(height: size.height * 0.02),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('¿Olvidaste tu contraseña?',
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                    onPressed: _signInWithEmailAndPassword,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                      ),
                      textStyle: TextStyle(fontSize: size.width * 0.045),
                    ),
                    child: const Text('Ingresar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'O',
                  style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.02),
                ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.g_mobiledata),
                        SizedBox(width: size.width * 0.02),
                        const Text(
                          'Ingresar con Google',
                        ),
                      ],
                    )),
                SizedBox(height: size.height * 0.01),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/Register');
                  },
                  child: Text(
                    '¿No tienes una cuenta? Regístrate',
                    style: TextStyle(
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        _emailController.text, _passwordController.text);
    if (result.success && mounted) {
      Navigator.pop(context);
    } else {
      _showErrorSnackBar(result.error);
    }
  }

  void _showErrorSnackBar(String? code) {
    String message;
    switch (code) {
      case 'invalid-credential':
        message = 'Credenciales inválidas';
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
