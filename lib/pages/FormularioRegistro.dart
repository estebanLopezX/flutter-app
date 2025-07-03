import 'package:flutter/material.dart';
import 'package:mi_disenio_app/clases/Familia.dart';
import 'package:mi_disenio_app/clases/Usuario.dart';
import 'dart:ui';
import 'package:mi_disenio_app/utilidades/CampoTexto.dart';
import 'package:mi_disenio_app/utilidades/memoria.dart';

class FormularioRegistro extends StatefulWidget {
  const FormularioRegistro({super.key});

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  bool aceptaTerminos = false;

  // Controladores de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarController = TextEditingController();

  @override
  void dispose() {
    // Liberar memoria cuando ya no se usan
    _nombreController.dispose();
    _correoController.dispose();
    _usuarioController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    super.dispose();
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTarjetaFormulario(),
                const SizedBox(height: 0),
                _buildTextoInferior(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTarjetaFormulario() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: const Color.fromARGB(153, 145, 202, 238),
        borderRadius: BorderRadius.circular(50),
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
          const SizedBox(height: 16),
          CampoTexto(
            label: "Nombre de la familia",
            hint: "Apellido o grupo familiar",
            controller: _nombreController,
          ),
          const SizedBox(height: 15),
          CampoTexto(
            label: "Correo electrónico",
            hint: "ejemplo@email.com",
            controller: _correoController,
          ),
          const SizedBox(height: 15),
          CampoTexto(
            label: "Usuario",
            hint: "Crea tu usuario",
            controller: _usuarioController,
          ),
          const SizedBox(height: 15),
          CampoTexto(
            label: "Contraseña",
            hint: "Mínimo 8 caracteres",
            esContrasena: true,
            controller: _contrasenaController,
          ),
          const SizedBox(height: 15),
          CampoTexto(
            label: "Confirmar contraseña",
            hint: "Repite tu contraseña",
            esContrasena: true,
            controller: _confirmarController,
          ),
          const SizedBox(height: 25),
          _buildBotonCrearCuenta(),
          const SizedBox(height: 5),
          _buildCheckTerminos(),
          const SizedBox(height: 5),
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
                  height: 120,
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
                  "REGISTRO",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Crea una cuenta para continuar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

  Widget _buildCheckTerminos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          Checkbox(
            value: aceptaTerminos,
            onChanged: (value) {
              setState(() {
                aceptaTerminos = value ?? false;
              });
            },
            activeColor: const Color(0xFF0088CB),
          ),
          const Expanded(
            child: Text(
              "Acepto los Términos y condiciones",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonCrearCuenta() {
    return SizedBox(
      width: 250,
      height: 35,
      child: ElevatedButton(
        onPressed: () {
          if (!aceptaTerminos) {
            _mostrarSnackBar("Debes aceptar los términos y condiciones");
          } else if (_contrasenaController.text != _confirmarController.text) {
            _mostrarSnackBar("Las contraseñas no coinciden");
          } else {
            // Crear instancia de Usuario
            Usuario nuevoUsuario = Usuario(
              usuario: _usuarioController.text,
              contrasenia: _contrasenaController.text,
            );

            // Crear instancia de Familia
            Familia nuevaFamilia = Familia(
              nombreFamilia: _nombreController.text,
              correo: _correoController.text,
              usuario: nuevoUsuario,
            );

            // Agregar a la lista
            Memoria.listaFamilias.add(nuevaFamilia);

            // Limpiar campos
            _nombreController.clear();
            _correoController.clear();
            _usuarioController.clear();
            _contrasenaController.clear();
            _confirmarController.clear();

            // Confirmación
            _mostrarSnackBar("Cuenta creada con éxito");

            // Esperar un segundo antes de redirigir (opcional, para que el SnackBar se vea)
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0088CB)),
                );
              },
            );

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop(); // Cierra el dialogo
              Navigator.of(context).pop(); // Vuelve a pantalla anterior
            });
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
          'Crear cuenta',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
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
          "REGISTRO",
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
