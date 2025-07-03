import 'package:flutter/material.dart';

class DetallesEmergencia extends StatelessWidget {
  final String emergencia;

  const DetallesEmergencia({super.key, required this.emergencia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de Emergencia'),
        backgroundColor: const Color(0xFF33a0d5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pasos a seguir para manejar la emergencia:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPasosEmergencia(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasosEmergencia() {
    List<String> pasos = [];

    switch (emergencia) {
      case 'Cortaduras y Heridas':
        pasos = [
          '1. Antes de tocar la herida, lávate bien las manos con agua y jabón para evitar infecciones . Si dispones de guantes desechables, úsalos para mayor seguridad .',
          '2. Aplica presión directa sobre la herida con una gasa estéril durante varios minutos hasta que el sangrado se detenga . Evita retirar la gasa para revisar la herida, ya que esto puede reiniciar el sangrado .',
          '3. Una vez controlado el sangrado, limpia la herida con suero fisiológico para eliminar suciedad o restos . Evita el uso de sustancias como agua oxigenada o alcohol, ya que pueden irritar la piel.',
          '4. Protege la herida con un apósito adhesivo estéril. Asegúrate de que el apósito esté bien adherido y no cause molestias.',
          '5. Revisa la herida diariamente para detectar signos de infección, como enrojecimiento, hinchazón, calor o pus . Si observas alguno de estos síntomas, consulta a un profesional de la salud.',
        ];
        break;
      case 'Fractura':
        pasos = [
          '1. Inmoviliza el área afectada.',
          '2. Aplica frío para reducir la inflamación.',
          '3. Evita mover la fractura, llama a emergencias.',
          '4. Transporta al afectado con precaución a un centro médico.',
        ];
        break;
      case 'Quemadura':
        pasos = [
          '1. Enfría la quemadura con agua fría por al menos 10 minutos.',
          '2. No revientes las ampollas.',
          '3. Aplica una crema hidratante si es necesario.',
          '4. Si la quemadura es grave, busca atención médica urgente.',
        ];
        break;
      case 'Asfixia':
        pasos = [
          '1. Si la persona está consciente, realizar la maniobra de Heimlich.',
          '2. Si la persona pierde la conciencia, realizar RCP.',
          '3. Llama a emergencias de inmediato.',
        ];
        break;
      case 'Paro Cardíaco':
        pasos = [
          '1. Realiza RCP inmediatamente (compresiones torácicas fuertes y rápidas).',
          '2. Si tienes acceso a un desfibrilador, úsalo.',
          '3. Llama a emergencias lo antes posible.',
        ];
        break;
      case 'Caídas y Golpes':
        pasos = [
          '1. Tranquiliza a la persona afectada: Revisa si está consciente y respira con normalidad',
          '2. Si la persona no puede moverse, se queja de dolor fuerte en la espalda, cuello o cabeza, o ha perdido el conocimiento, no la muevas.Llama inmediatamente al número de emergencia del hospital.',
          '3. Busca hematomas, heridas, hinchazón o deformidades. Observa si puede mover brazos y piernas sin dolor intenso. Pregunta si siente mareo, visión borrosa o náuseas (signos de golpe en la cabeza)',
          '4. Limpia heridas leves si las hay (ver cómo atender heridas). ',
          '5. Aplica hielo en la zona golpeada. Coloca hielo envuelto en un paño durante 15-20 minutos. Esto ayuda a reducir la hinchazón y el dolor. No pongas hielo directamente sobre la piel.',
          '6. Si hay golpe en un brazo o pierna, eleva la extremidad para ayudar a bajar la hinchazón.',
          '7. Vigila si aparecen dolor intenso, moretones que crecen, fiebre o limitación para moverse. En caso de golpe en la cabeza, observa si presenta: Somnolencia. Vómito. Confusión. Pupilas desiguales. Pérdida de memoria.',
          '8. El dolor es fuerte o no mejora en 24-48 horas. Hay sangrado persistente. Sospechas de fractura. El golpe fue en la cabeza y hay síntomas neurológicos.',
        ];
      case 'Otro':
        pasos = [
          '1. Evalúa la situación.',
          '2. Realiza los primeros auxilios básicos según la emergencia.',
          '3. Llama a emergencias si es necesario.',
        ];
        break;
      default:
        pasos = ['No se han definido pasos para esta emergencia.'];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          pasos
              .map(
                (paso) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(paso, style: TextStyle(fontSize: 16)),
                ),
              )
              .toList(),
    );
  }
}
