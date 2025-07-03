import 'package:flutter/material.dart';

class CampoTexto extends StatefulWidget {
  final String label;
  final String hint;
  final bool esContrasena;
  final TextEditingController? controller;

  const CampoTexto({
    super.key,
    required this.label,
    required this.hint,
    this.esContrasena = false,
    this.controller,
  });

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  bool _ocultarTexto = true;

  // Función para limpiar los espacios al final
  void _limpiarEspaciosAlFinalizar() {
    String currentText = widget.controller?.text ?? '';
    widget.controller?.text =
        currentText.trimRight(); // Elimina espacios solo al final
    // Mover el cursor al final del texto
    widget.controller?.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller!.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 260,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.white,
                selectionColor: Colors.white30,
                selectionHandleColor: Colors.white,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.esContrasena ? _ocultarTexto : false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 0,
                ),
                suffixIcon:
                    widget.esContrasena
                        ? IconButton(
                          icon: Icon(
                            _ocultarTexto
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _ocultarTexto = !_ocultarTexto;
                            });
                          },
                        )
                        : null,
              ),
              onEditingComplete:
                  _limpiarEspaciosAlFinalizar, // Limpiar al finalizar
            ),
          ),
        ),
      ],
    );
  }
}
