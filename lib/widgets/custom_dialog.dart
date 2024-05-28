import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ds250/core/app_export.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String icon;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;
  final bool noInternet;

  const CustomDialog({super.key,
    required this.title,
    required this.message,
    this.onOkPressed,
    this.onCancelPressed,
    this.confirmButtonText = "OK",
    this.cancelButtonText = "Cancelar",
    this.icon = "",
    this.noInternet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            iconWidget(icon),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            ButtonBar(
              mainAxisSize: MainAxisSize.max,
              alignment: MainAxisAlignment.center,
              children: [
                if (onOkPressed != null)
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: onOkPressed,
                      child: Ink(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 26, 255),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(confirmButtonText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                if (onCancelPressed != null)
                  TextButton(
                    onPressed: onCancelPressed,
                    child: Text(cancelButtonText, style: TextStyle(fontWeight: FontWeight.w700, color: Color.fromARGB(250, 0, 123, 254)),),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget iconWidget(String type){
    Color color = Color.fromARGB(255, 251, 241, 232);
    Icon icon = Icon(Icons.warning_amber_rounded, color: Color.fromARGB(255, 235, 104, 21));
    if(type == "error"){
      color = Color.fromARGB(255, 248, 236, 241);
      icon = Icon(Icons.close_rounded, color: Color.fromARGB(255, 201, 26, 47));
    }else if(type == "info"){
      color = Color.fromARGB(255, 220, 220, 250);
      icon = Icon(Icons.error_outline, color: Color.fromARGB(255, 26, 47, 201));
    }else if(type == "success"){
      color = Color.fromARGB(255, 220, 250, 220);
      icon = Icon(Icons.check, color: Color.fromARGB(255, 26, 201, 26));
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color
      ),
      child: icon,
    );
  }

}