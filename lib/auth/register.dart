import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  bool isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _registerWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/Home');
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'El correo ya está en uso';
          break;
        case 'weak-password':
          message = 'La contraseña es muy débil';
          break;
        default:
          message = 'Error desconocido';
      }
      _showErrorSnackBar(message);
    }
  }

  Future<void> _registerWithGoogle() async {
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
          ? _showErrorSnackBar('Ya existe una cuenta con otro proveedor')
          : _showErrorSnackBar('Error desconocido');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
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
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_circle),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              const TextField(
                decoration: InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 20),
              TextField(
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
                  onPressed: _registerWithGoogle,
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
}
