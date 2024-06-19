import 'package:ds250/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Desenvolvedor', style: TextStyle(color: Colors.white, fontSize: 25.sp),),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0, top: 8.0), // Adiciona espaçamento à direita da imagem
            child:Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                  borderRadius: BorderRadius.circular(100)
              ),
              padding: EdgeInsets.all(2),
              child: CustomImageView(
                imagePath: ImageConstant.imgProfilePic,
                radius: BorderRadius.circular(100),
                width: 45,
                height: 45,
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFirstRow(),
            _buildCustomListTile(FontAwesomeIcons.user, "Felipe Bomfim", false),
            Divider(color: Colors.white12,),
            _buildCustomListTile(FontAwesomeIcons.envelope, "felipebomfim@ufpr.br", false),
            Divider(color: Colors.white12,),
            _buildCustomListTile(FontAwesomeIcons.calendar, "Última atualização: 18/06/2024", false),
            Divider(color: Colors.white12,),
            // Divider(color: Colors.black12,),
            // _buildCustomListTile(Icons.phone_outlined, user?.celular == "" ? "Sem informações" : user?.celular ?? "", false),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('Ações',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900
                ),
              ),
            ),
            Divider(color: Colors.black12,),
            _buildCustomListTile(FontAwesomeIcons.linkedin, "Linkedin" ?? "N/A", true, onTap: openLinkedin),
            Divider(color: Colors.black12,),
          ],
        ),
      ),
    );
  }

  void openLinkedin() async {
    _launchSocialMediaAppIfInstalled(
      url: 'https://www.linkedin.com/in/felipe-bomfim-836868197/', // Linkedin
    );
  }

  Future<void> _launchSocialMediaAppIfInstalled({
    required String url,
  }) async {
    try {
      bool launched = await launch(url, forceSafariVC: false); // Launch the app if installed!

      if (!launched) {
        launch(url); // Launch web view if app is not installed!
      }
    } catch (e) {
      launch(url); // Launch web view if app is not installed!
    }
  }

  Widget _buildFirstRow() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Informações',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w900
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomListTile(IconData icon, String name, bool showTrailing, {Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: onTap == null ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 30, 30, 30),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 15,),
        ),
      ) : Icon(icon, color: Colors.white, size: 22,),
      minLeadingWidth: 10,
      title: Text(
        "${name}",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
      trailing: showTrailing ? Icon(Icons.arrow_forward_ios_outlined, color: Colors.white, size: 15,) : null,
    );
  }
}