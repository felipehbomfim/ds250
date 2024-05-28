import 'package:flutter/cupertino.dart';

Future<dynamic> onNavigate(BuildContext context, String routeName, {dynamic arguments}) async {
  final result = await Navigator.pushNamed(
    context,
    routeName,
    arguments: arguments,
  );
  // O resultado (result) pode ser qualquer coisa que você optar por retornar das telas para as quais navegou
  return result;
}