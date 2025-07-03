import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Navigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIconTapped;

  const Navigation({
    Key? key,
    required this.selectedIndex,
    required this.onIconTapped,
  }) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color.fromARGB(179, 170, 204, 240),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavIcon(
            0,
            null,
            customIcon: Image.asset(
              'images/hogar.png',
              width: 30,
              height: 30,
              color:
                  widget.selectedIndex == 0 ? Color(0xFF0088CB) : Colors.black,
            ),
          ),
          _buildNavIcon(
            1,
            null,
            customIcon: Image.asset(
              'images/usuario-nave.png',
              width: 30,
              height: 30,
              color: widget.selectedIndex == 1 ? Colors.blue : Colors.black,
            ),
          ),
          _buildNavIcon(
            2,
            null,
            customIcon: Image.asset(
              'images/botiquin.png',
              width: 30,
              height: 30,
              color: widget.selectedIndex == 2 ? Colors.blue : Colors.black,
            ),
          ),
          _buildNavIcon(
            3,
            null,
            customIcon: Image.asset(
              'images/emergencias.png',
              width: 30,
              height: 30,
              color:
                  widget.selectedIndex == 3 ? Colors.blue : Color(0xFFFF6666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(int index, IconData? icon, {Widget? customIcon}) {
    return InkWell(
      onTap: () {
        widget.onIconTapped(index);
        if (index == 3) {
          _makeEmergencyCall();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child:
            customIcon ??
            Icon(
              icon,
              size: 30,
              color: widget.selectedIndex == index ? Colors.blue : Colors.grey,
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
