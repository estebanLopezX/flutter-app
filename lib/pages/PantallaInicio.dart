import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mi_disenio_app/pages/FormularioRegistro.dart';
import 'package:mi_disenio_app/utilidades/CampoTexto.dart';
import 'package:mi_disenio_app/utilidades/PantallaBase.dart';
import 'package:mi_disenio_app/utilidades/memoria.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    final logueado = prefs.getBool('logueado') ?? false;

    if (logueado) {
      // Redirige directamente a PantallaBase si ya estaba logueado
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PantallaBase()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            center: Alignment.centerRight,
            startAngle: 0.0,
            endAngle: 6.99999,
            stops: [0.43, 0.94],
            colors: [Color(0xFF0088CB), Color(0xFF78B4D2)],
          ),
        ),
        child: Center(child: _buildBienvenida(context)),
      ),
    );
  }

  Widget _buildBienvenida(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildTarjeta(context), _buildTextoInferior()],
    );
  }

  Widget _buildTarjeta(BuildContext context) {
    return Container(
      width: 320,
      height: 500,
      decoration: BoxDecoration(
        color: const Color.fromARGB(153, 145, 202, 238),
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildImagenEncabezado(),
          const SizedBox(height: 32),
          CampoTexto(
            label: "USUARIO",
            hint: "Escribe tu Usuario.",
            controller: _usuarioController,
          ),
          const SizedBox(height: 30),
          CampoTexto(
            label: "CONTRASEÑA",
            hint: "Escribe tu Contraseña.",
            esContrasena: true,
            controller: _contraseniaController,
          ),
          const SizedBox(height: 25),
          _buildBotonAcceder(context),
          const SizedBox(height: 20),
          _buildBotonesSecundarios(context),
        ],
      ),
    );
  }

  Widget _buildImagenEncabezado() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: Image.network(
                  'https://amiif.org/wp-content/uploads/2023/07/aplicacion-de-ia-para-el-descubrimiento-de-farmacos-900x600.jpeg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: const Color.fromARGB(117, 0, 0, 0)),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "BIENVENIDO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Sistema Integral de Prevención de Lesiones",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotonAcceder(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 35,
      child: ElevatedButton(
        onPressed: () async {
          String usuarioIngresado = _usuarioController.text;
          String contraseniaIngresada = _contraseniaController.text;

          bool usuarioValido = false;

          for (var familia in Memoria.listaFamilias) {
            if (familia.usuario.usuario == usuarioIngresado &&
                familia.usuario.contrasenia == contraseniaIngresada) {
              usuarioValido = true;
              Memoria.familiaLogueada = familia;

              // 🔐 Guardar sesión en SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('usuarioLogueado', usuarioIngresado);

              break;
            }
          }

          if (usuarioValido) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('logueado', true);
            await prefs.setString('usuarioLogueado', usuarioIngresado);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PantallaBase()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuario o contraseña incorrectos.'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0088CB),
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Acceder',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBotonesSecundarios(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormularioRegistro(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Text(
                "REGISTRARME",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              print("Olvidé la contraseña");
            },
            child: const Text(
              "OLVIDÉ LA CONTRASEÑA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextoInferior() {
    return Container(
      width: 190,
      height: 45,
      decoration: BoxDecoration(
        color: const Color.fromARGB(153, 145, 202, 238),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "INICIAR SESIÓN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
