import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mi_disenio_app/clases/Familia.dart';
import 'package:mi_disenio_app/clases/Item.dart';
import 'package:mi_disenio_app/pages/DetallesEmergencia.dart';
import 'package:mi_disenio_app/utilidades/memoria.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaSecundaria extends StatefulWidget {
  final Familia familia;

  const PantallaSecundaria({super.key, required this.familia});

  @override
  State<PantallaSecundaria> createState() => _PantallaSecundariaState();
}

class _PantallaSecundariaState extends State<PantallaSecundaria>
    with SingleTickerProviderStateMixin {
  String? _selectedEmergencia;
  final TextEditingController _buscarController = TextEditingController();

  final List<String> _emergencias = [
    'Seleccione un Tipo de Emergencia',
    'Cortaduras y Heridas',
    'Fractura',
    'Quemadura',
    'Asfixia',
    'Paro Cardíaco',
    'Caídas y Golpes',
    'Otro',
  ];

  bool _isLoading = false;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _buscarController.dispose();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: Column(
            children: [
              _buildCard(context),
              const SizedBox(height: 10),
              const Text(
                'Elegir tipo de Emergencia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedEmergencia,
                    hint: const Text('Seleccione una emergencia'),
                    items:
                        _emergencias.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEmergencia = newValue;
                        _buscarController.text = newValue ?? '';
                      });
                    },
                    underline: const SizedBox(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Buscar tipo de emergencia',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _buscarController,
                    textAlign: TextAlign.left,
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: 'Buscar...',
                      hintStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _makeEmergencyCall();
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6666),
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                        ),
                        child: const Text(
                          'ATENCIÓN\nRÁPIDA',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          if (_selectedEmergencia != null &&
                              _selectedEmergencia !=
                                  'Seleccione un Tipo de Emergencia') {
                            setState(() => _isLoading = true);
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() => _isLoading = false);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetallesEmergencia(
                                      emergencia: _selectedEmergencia!,
                                    ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor, selecciona una emergencia',
                                ),
                              ),
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'BUSCAR',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(opacity: _fadeAnimation, child: _buildNewCard()),
              const SizedBox(height: 20),
              if (_selectedEmergencia != null &&
                  _selectedEmergencia != 'Seleccione un Tipo de Emergencia')
                _buildBotiquinCard(_selectedEmergencia!),
            ],
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

  Widget _buildCard(BuildContext context) {
    return Card(
      color: const Color(0xFF33a0d5),
      margin: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUserIcon(),
                const SizedBox(height: 20),
                _buildUserInfoRow(
                  'Nombre Familia:',
                  widget.familia.nombreFamilia,
                ),
                const SizedBox(height: 10),
                _buildUserInfoRow('Correo Electrónico:', widget.familia.correo),
                const SizedBox(height: 10),
                _buildActionButtons(),
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () async {
                  Memoria.familiaLogueada = null;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('logueado');
                  await prefs.remove('usuarioLogueado');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCard() {
    return AnimatedOpacity(
      opacity:
          _selectedEmergencia != null &&
                  _selectedEmergencia != 'Seleccione un Tipo de Emergencia'
              ? 1.0
              : 0.0,
      duration: const Duration(milliseconds: 400),
      child: Card(
        color: const Color(0xFF33a0d5),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              _buildUserInfoRow(
                'Emergencia seleccionada:',
                _selectedEmergencia ?? 'No seleccionada',
              ),
              const SizedBox(height: 10),
              _buildUserInfoRow('Detalles:', 'Detalles de la emergencia'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotiquinCard(String emergencia) {
    final Map<String, List<String>> itemsPorEmergencia = {
      'Cortaduras y Heridas': ['Gasas', 'Alcohol', 'Curitas'],
      'Fractura': ['Férula', 'Venda elástica'],
      'Quemadura': ['Pomada para quemaduras', 'Gasas estériles'],
      'Asfixia': ['Respirador manual'],
      'Paro Cardíaco': ['Desfibrilador', 'Guantes'],
      'Caídas y Golpes': ['Vendas elásticas', 'Esparadrapo'],
      'Otro': [],
    };

    List<String> itemsNecesarios = itemsPorEmergencia[emergencia] ?? [];

    final List<Item> botiquinDisponible =
        Memoria.familiaLogueada?.botiquin ?? [];

    List<Widget> itemWidgets =
        itemsNecesarios.map((item) {
          // Contamos la cantidad total de un item en el botiquín
          int cantidadDisponible = botiquinDisponible
              .where(
                (botiquinItem) =>
                    botiquinItem.nombre.trim().toLowerCase() ==
                    item.trim().toLowerCase(),
              )
              .fold(
                0,
                (prev, curr) => prev + curr.cantidad,
              ); // Sumamos las cantidades

          bool disponible = cantidadDisponible > 0;

          return ListTile(
            leading: Icon(
              disponible ? Icons.check_circle : Icons.cancel,
              color: disponible ? Colors.green : Colors.red,
            ),
            title: Text(
              item,
              style: TextStyle(
                color: disponible ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              disponible ? 'Disponible: $cantidadDisponible' : 'No disponible',
            ),
          );
        }).toList();

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elementos necesarios del Botiquín',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...itemWidgets,
          ],
        ),
      ),
    );
  }

  Widget _buildUserIcon() {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: const CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Colors.black, size: 55),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              print('Botón 1 presionado');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const SizedBox(
              width: 90,
              child: Text(
                'Cambiar\nContraseña',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print('Botón 2 presionado');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const SizedBox(
              width: 80,
              child: Text(
                'Completar\nDatos',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
