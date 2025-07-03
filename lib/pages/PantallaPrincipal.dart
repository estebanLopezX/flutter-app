import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui'; // Para BackdropFilter
import 'package:permission_handler/permission_handler.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  bool _cargarContenido = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _cargarContenido = true;
      });
    });
  }

  Future<void> _makeEmergencyCall() async {
    // Verificar y solicitar permiso
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    if (status.isGranted) {
      // Intentar hacer la llamada
      bool? res = await FlutterPhoneDirectCaller.callNumber("911");
      if (res == null || res == false) {
        print('No se pudo realizar la llamada');
      }
    } else {
      print('Permiso de llamada denegado');
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
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "BIENVENIDO",
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Sistema Integral de Prevención",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              " de Lesiones",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botonPrincipal(
                  context,
                  "ATENCIÓN\nRÁPIDA",
                  Icons.medical_services,
                  const Color(0xFFFF6666),
                  Colors.white,
                  Colors.white,
                  _makeEmergencyCall,
                ),
                _botonPrincipal(
                  context,
                  "BUSCAR\nVIDEOS",
                  Icons.video_library,
                  Colors.white,
                  const Color(0xFF0088CB),
                  Colors.white,
                  () {
                    print("Buscar videos presionado");
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_cargarContenido)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.62,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSection(
                        title: "PRIMEROS AUXILIOS",
                        videoUrls: [
                          'https://www.youtube.com/watch?si=B09ukhPix5IZkg3s&v=F07Hj2bFJoA&feature=youtu.be',
                          'https://www.youtube.com/watch?v=_QA1vIocEw8',
                          'https://www.youtube.com/watch?si=L6i3XegPVu4PnXKa&v=cECkv6xUuTY&feature=youtu.be',
                        ],
                      ),
                      _buildSection(
                        title: "EJERCICIOS Y RUTINAS",
                        videoUrls: [
                          'https://www.youtube.com/watch?v=C8NcifEVk0Y',
                          'https://www.youtube.com/watch?v=MPzfQMxrjdQ',
                        ],
                      ),
                      _buildSection(
                        title: "AUTOESTIMA Y CONFIANZA",
                        videoUrls: [
                          'https://www.youtube.com/watch?v=y3vrDj2-CfQ',
                          'https://www.youtube.com/watch?v=KWdrwp7K_rU',
                        ],
                      ),
                      _buildSection(
                        title: "NUTRICIÓN SALUDABLE",
                        videoUrls: [
                          'https://www.youtube.com/watch?v=dxH__2x0p-I',
                          'https://www.youtube.com/watch?v=cJRtY9TenFY',
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _botonPrincipal(
    BuildContext context,
    String texto,
    IconData icono,
    Color bgColor,
    Color textColor,
    Color borderColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono, color: textColor),
      label: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor, width: 2),
        ),
        minimumSize: const Size(160, 50),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> videoUrls,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color.fromARGB(179, 170, 204, 240),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    videoUrls.map((url) {
                      return SizedBox(
                        width: 270,
                        child: GestureDetector(
                          onTap: () => _abrirEnlace(url),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: _getYoutubeThumbnail(url),
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget:
                                  (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getYoutubeThumbnail(String url) {
    final uri = Uri.parse(url);
    final videoId = uri.queryParameters['v'];
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  void _abrirEnlace(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir el enlace: $url';
    }
  }
}
