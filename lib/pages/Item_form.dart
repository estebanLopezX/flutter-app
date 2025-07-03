import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_disenio_app/clases/Item.dart';

const Color blanco = Color(0xFFFFFFFF); 
const Color colorPrincipal = Color.fromARGB(
  255,
  44,
  134,
  245,
); // Color principal

class ItemForm extends StatefulWidget {
  final Item? item;
  final Function(Item) onSubmit;

  ItemForm({this.item, required this.onSubmit});

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  late String nombre;
  late int cantidad;
  late String tipo;
  late DateTime fechaVencimiento;
  late String notas;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    nombre = item?.nombre ?? '';
    cantidad = item?.cantidad ?? 1;
    tipo = item?.tipo ?? 'Medicamento';
    fechaVencimiento = item?.fechaVencimiento ?? DateTime.now();
    notas = item?.notas ?? '';
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fechaVencimiento,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        fechaVencimiento = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: SweepGradient(
          center: Alignment.centerRight,
          startAngle: 0.0,
          endAngle: 6.99999,
          stops: [0.43, 0.94],
          colors: [Color(0xFF0088CB), Color(0xFF78B4D2)],
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 16,
        top: 50,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInput(
                label: 'Nombres',
                initialValue: nombre,
                onSaved: (value) => nombre = value!,
                validator:
                    (value) => value!.isEmpty ? 'Campo obligatorio' : null,
                inputFormatters: [
                  // Capitalizar la primera letra
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text;
                    if (text.isNotEmpty) {
                      return newValue.copyWith(
                        text: text[0].toUpperCase() + text.substring(1),
                        selection: TextSelection.collapsed(offset: text.length),
                      );
                    }
                    return newValue;
                  }),
                ],
              ),
              _buildInput(
                label: 'Cantidad',
                initialValue: cantidad.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) => cantidad = int.parse(value!),
              ),
              _buildDropdown(),
              _buildInput(
                label: 'Notas',
                initialValue: notas,
                onSaved: (value) => notas = value!,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    "Vence: ${fechaVencimiento.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(color: blanco),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: pickDate,
                    child: Text('Cambiar Fecha'),
                    style: TextButton.styleFrom(foregroundColor: blanco),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      widget.onSubmit(
                        Item(
                          nombre: nombre,
                          cantidad: cantidad,
                          tipo: tipo,
                          fechaVencimiento: fechaVencimiento,
                          notas: notas,
                        ),
                      );
                      // Limpiar los campos después de guardar
                      setState(() {
                        nombre = '';
                        cantidad = 1;
                        tipo = 'Medicamento';
                        fechaVencimiento = DateTime.now();
                        notas = '';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blanco,
                    foregroundColor: colorPrincipal,
                  ),
                  child: Text('Guardar'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String initialValue,
    required void Function(String?) onSaved,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 8, 8, 8),
          ), // ← Etiqueta blanca
          filled: true,
          fillColor: blanco,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorPrincipal, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
        cursorColor: colorPrincipal,
        inputFormatters: inputFormatters,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: tipo,
        decoration: InputDecoration(
          labelText: 'Tipo',
          labelStyle: TextStyle(
            color: const Color.fromARGB(255, 0, 0, 0),
          ), // ← Etiqueta blanca
          filled: true,
          fillColor: blanco,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorPrincipal, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        items:
            [
              'Medicamento',
              'Desinfectante',
              'Vendaje',
              'Otro',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (value) => setState(() => tipo = value!),
      ),
    );
  }
}
