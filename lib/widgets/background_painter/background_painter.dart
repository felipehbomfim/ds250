import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color.fromARGB(255, 104, 177, 189); //Cor do plano de fundo
    var path = Path();
    path.lineTo(0, size.width * 0.6); // Comece no canto inferior esquerdo
    path.quadraticBezierTo(size.width * 0.4, size.width * 0.9, size.width, size.width * 0.5); // Curva da direita
    path.lineTo(size.width, 0); // Retorne ao canto superior direito
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}