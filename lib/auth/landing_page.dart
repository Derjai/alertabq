import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String logopath = isDarkMode
        ? 'assets/images/landing_dark.svg'
        : 'assets/images/landing.svg';
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.02),
                SvgPicture.asset(
                  logopath,
                  semanticsLabel: 'Imagen_inicio',
                  width: size.width * 0.45,
                  height: size.height * 0.45,
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  'Bienvenido a AlertaBQ!',
                  style: TextStyle(
                      fontSize: size.width * 0.07, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'Crea una cuenta o inicia sesión para continuar',
                  style: TextStyle(fontSize: size.width * 0.045),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.04),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                      ),
                      textStyle: TextStyle(fontSize: size.width * 0.045),
                    ),
                    child: const Text('Iniciar sesión',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                      ),
                      textStyle: TextStyle(fontSize: size.width * 0.045),
                    ),
                    child: const Text('Crear cuenta',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Center(
                    child: Text(
                  'AlertaBQ 2024 © Todos los derechos reservados',
                  style: TextStyle(fontSize: size.width * 0.025),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
