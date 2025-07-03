import 'package:mi_disenio_app/clases/Familia.dart';
import 'package:mi_disenio_app/clases/Item.dart';
import 'package:mi_disenio_app/clases/Usuario.dart';

class Memoria {
  static List<Familia> listaFamilias = [
    Familia(
      nombreFamilia: 'Familia fm1',
      correo: 'familia1@correo.com',
      usuario: Usuario(usuario: 'user1', contrasenia: 'contraseña1'),
    ),
    Familia(
      nombreFamilia: 'Familia fm2',
      correo: 'familia2@correo.com',
      usuario: Usuario(usuario: 'user2', contrasenia: 'contraseña2'),
      botiquin: [],
    ),
    Familia(
      nombreFamilia: 'Familia fm3',
      correo: 'familia3@correo.com',
      usuario: Usuario(usuario: 'user3', contrasenia: 'contraseña3'),
      botiquin: [],
    ),
  ];

  static Familia? familiaLogueada; // Familia logueada

  static List<Item> obtenerBotiquinFamiliaLogueada() {
    if (familiaLogueada != null) {
      return familiaLogueada!.botiquin;
    } else {
      return []; // Si no hay familia logueada, devuelve una lista vacía
    }
  }

  // Limpiar la sesión
  static void clearSesion() {
    familiaLogueada = null;
  }
}
