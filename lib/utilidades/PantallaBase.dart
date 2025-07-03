import 'package:flutter/material.dart';
import 'package:mi_disenio_app/clases/Familia.dart';
import 'package:mi_disenio_app/pages/PantallaBotiquin.dart';
import 'package:mi_disenio_app/pages/PantallaInicio.dart';
import 'package:mi_disenio_app/pages/PantallaPrincipal.dart';
import 'package:mi_disenio_app/pages/PantallaSecundaria.dart';
import 'package:mi_disenio_app/utilidades/Navigation.dart';
import 'package:mi_disenio_app/utilidades/memoria.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaBase extends StatefulWidget {
  const PantallaBase({super.key});

  @override
  State<PantallaBase> createState() => _PantallaBaseState();
}

class _PantallaBaseState extends State<PantallaBase> {
  int _selectedIndex = 0;

  Familia familiaSeleccionada =
      Memoria.listaFamilias[0]; 

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return const PantallaPrincipal();
      case 1:
        if (Memoria.familiaLogueada != null) {
          return PantallaSecundaria(familia: Memoria.familiaLogueada!);
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No se ha iniciado sesión',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Limpiar memoria RAM
                    Memoria.familiaLogueada = null;

                    // Limpiar memoria persistente
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('logueado');
                    await prefs.remove('usuarioLogueado');

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const PantallaInicio(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }
      case 2:
        return const PantallaBotiquin();
      default:
        return const Center(child: Text('Realizando Llamada...'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: Navigation(
        selectedIndex: _selectedIndex,
        onIconTapped: _onIconTapped,
      ),
    );
  }
}
