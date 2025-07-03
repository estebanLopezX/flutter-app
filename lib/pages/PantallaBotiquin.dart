import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mi_disenio_app/clases/Item.dart';
import 'package:mi_disenio_app/utilidades/memoria.dart';
import 'item_form.dart';
import 'package:flutter_animate/flutter_animate.dart';

const Color azulClaro = Color(0xFFB3D4FC);
const Color blanco = Color(0xFFFFFFFF);

class PantallaBotiquin extends StatefulWidget {
  const PantallaBotiquin({Key? key}) : super(key: key);

  @override
  _BotiquinState createState() => _BotiquinState();
}

class _BotiquinState extends State<PantallaBotiquin> {
  // No necesitamos la lista items local porque usamos Memoria

  List<Item> get items => Memoria.familiaLogueada?.botiquin ?? [];

  void addItem(Item item) {
    setState(() {
      Memoria.familiaLogueada?.botiquin.add(item);
    });
  }

  void updateItem(int index, Item newItem) {
    setState(() {
      Memoria.familiaLogueada?.botiquin[index] = newItem;
    });
  }

  void deleteItem(int index) {
    setState(() {
      Memoria.familiaLogueada?.botiquin.removeAt(index);
    });
  }

  void showItemForm({Item? item, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ItemForm(
              item: item,
              onSubmit: (newItem) {
                if (index == null) {
                  addItem(newItem);
                } else {
                  updateItem(index, newItem);
                }
                Navigator.pop(context);
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'MI BOTIQUÍN',
                    style: TextStyle(
                      color: blanco,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: size.width * 0.9,
                    height: size.height * 0.75,
                    decoration: BoxDecoration(
                      color: azulClaro,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 85),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _makeEmergencyCall();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6666),
                                  foregroundColor: blanco,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                      color: blanco,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'ATENCIÓN\nRÁPIDA',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child:
                                items.isEmpty
                                    ? const Center(
                                      child: Text(
                                        'Sin elementos',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    )
                                    : ListView.builder(
                                      itemCount: items.length,
                                      itemBuilder: (_, index) {
                                        final item = items[index];
                                        return Animate(
                                          effects: [
                                            FadeEffect(duration: 500.ms),
                                            ScaleEffect(duration: 500.ms),
                                            SlideEffect(
                                              begin: Offset(0, 1),
                                              duration: 500.ms,
                                            ),
                                          ],
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: blanco,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                item.nombre,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              subtitle: Text(
                                                'Cantidad: ${item.cantidad} \nVence: ${item.fechaVencimiento.toLocal().toString().split(' ')[0]}',
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    onPressed:
                                                        () => showItemForm(
                                                          item: item,
                                                          index: index,
                                                        ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.redAccent,
                                                    ),
                                                    onPressed:
                                                        () => deleteItem(index),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () => showItemForm(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blanco,
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  84,
                                  161,
                                  255,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 84, 161, 255),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _makeEmergencyCall() async {
    bool? res = await FlutterPhoneDirectCaller.callNumber("911");
    if (res == null || res == false) {
      print('No se pudo realizar la llamada');
    }
  }
}
