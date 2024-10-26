import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/Home');
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no encontrado';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta';
          break;
        default:
          message = 'Error desconocido';
      }
      _showErrorSnackBar(message);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/Home');
      }
    } on FirebaseAuthException catch (e) {
      e.code == 'account-exists-with-different-credential'
          ? _showErrorSnackBar('Ya existe una cuenta con este correo')
          : _showErrorSnackBar('Error desconocido');
    }
  }

  Future<void> _resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showErrorSnackBar('Correo de recuperación enviado');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no encontrado';
          break;
        default:
          message = 'Error desconocido';
      }
      _showErrorSnackBar(message);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    ));
  }

  void _showResetPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar contraseña'),
          content: TextField(
            controller: resetEmailController,
            decoration: const InputDecoration(
              labelText: 'Ingresar correo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _resetPassword(resetEmailController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Enviar correo'),
            ),
          ],
        );
      },
    );
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
                    onPressed: () {
                      _showResetPasswordDialog();
                    },
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
                    onPressed: _signInWithGoogle,
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
}
