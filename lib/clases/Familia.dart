import 'package:mi_disenio_app/clases/Usuario.dart';
import 'package:mi_disenio_app/clases/Item.dart'; 

class Familia {
  final String nombreFamilia;
  final String correo;
  final Usuario usuario;
  List<Item> botiquin; // Lista de ítems para esta familia

  Familia({
    required this.nombreFamilia,
    required this.correo,
    required this.usuario,
    List<Item>? botiquin, 
  }) : botiquin = botiquin ?? [];
}
