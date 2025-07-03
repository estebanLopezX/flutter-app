import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mi_disenio_app/pages/PantallaInicio.dart';
import 'package:mi_disenio_app/utilidades/PantallaBase.dart';
import 'package:mi_disenio_app/utilidades/memoria.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _estaLogueadoYConfiguraMemoria() async {
    final prefs = await SharedPreferences.getInstance();
    final logueado = prefs.getBool('logueado') ?? false;

    if (logueado) {
      final usuarioGuardado = prefs.getString('usuarioLogueado');

      if (usuarioGuardado != null) {
        for (var familia in Memoria.listaFamilias) {
          if (familia.usuario.usuario == usuarioGuardado) {
            Memoria.familiaLogueada = familia;
            break;
          }
        }
      }
    }

    return logueado;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIPL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/login': (context) => const PantallaInicio(),
        '/base': (context) => const PantallaBase(),
      },
      home: FutureBuilder<bool>(
        future: _estaLogueadoYConfiguraMemoria(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            return const PantallaBase(); // Ya logueado
          } else {
            return const PantallaInicio(); // Ir al login
          }
        },
      ),
    );
  }
}
