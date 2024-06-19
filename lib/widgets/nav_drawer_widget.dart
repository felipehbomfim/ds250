import 'dart:io';

import 'package:ds250/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final VoidCallback? onLogout;
  NavigationDrawerWidget({this.onLogout});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  int drawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imageAsset = ImageConstant.imgProfilePic;

    String userName = "";
    if (userName.isNotEmpty) {
      List<String> nameParts = userName.split(" ");
      if (nameParts.length > 1) {
        userName = "${nameParts[0]} ${nameParts.last}";
      }
    }

    return NavigationDrawer(
      backgroundColor: Color.fromARGB(255, 3, 3, 3),
      selectedIndex: drawerIndex,
      onDestinationSelected: (int drawerI){
        setState(() {
          drawerIndex = drawerI;
        });

        if(drawerIndex == 1){
          onNavigate(context, AppRoutes.aboutScreen);
        }
      },
      indicatorColor: Color.fromARGB(255, 28, 28, 28),
      children: <Widget>[
        DrawerHeader(
          child:  buildHeader(
            imageAsset: imageAsset,
            name: "Felipe Bomfim",
            onClicked: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => UserPage(
              //     name: userName,
              //     imageAsset: imageAsset,
              //   ),
              // ));
            },
          ),
        ),

        ListTile(
          dense: true,
          title: Text(
            "Menu principal",
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),

        NavigationDrawerDestination(
          selectedIcon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          icon: Icon(
            Icons.home_outlined,
            color: Colors.white,
          ),
          label: Text('Home', style: TextStyle(color: Colors.white, fontSize: 12.sp),),
        ),
        NavigationDrawerDestination(
          selectedIcon: FaIcon(FontAwesomeIcons.infoCircle, color: Colors.white, size: 16,),
          icon: FaIcon(FontAwesomeIcons.infoCircle, color: Colors.white, size: 16,),
          label: Text('Sobre', style: TextStyle(color: Colors.white, fontSize: 12.sp),),
        ),
      ],
    );
  }

  void selectItem(int index) {
    setState(() {
      drawerIndex = index;
      Navigator.pop(context); // Fecha o drawer
    });
    // Adicione sua lógica de navegação aqui
  }

  Widget buildHeader({
    required String imageAsset,
    required String name,
    required VoidCallback onClicked,
  }) => InkWell(
    // onTap: onClicked,
    child: Container(
      padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
      child: Row(
        children: [
          // CircleAvatar(
          //   radius: 50, // Aumenta o raio para 50. O padrão é cerca de 20.
          //   backgroundColor: Colors.white,
          //   backgroundImage: AssetImage(imageAsset),
          // ),

          SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: imageAsset.isNotEmpty && File(imageAsset).existsSync()
                  ? Image.file(
                File(imageAsset),
                fit: BoxFit.fill,
              ) : Image.asset(imageAsset, fit: BoxFit.fill),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
