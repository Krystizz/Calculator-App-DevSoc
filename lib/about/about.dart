import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../globals.dart' as globals;

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Future<void>? launched;

  Future<void> getVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      globals.version = packageInfo.version;
    });
  }

  Future<void> openUrl(Uri url) async {
    if (!await launchUrl(url)) {
      if (mounted) globals.showErrorMessage('Could not launch $url', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    SizedBox webButton(String url, String txt, Widget icon) {
      double x = 0.8, y = 0.08;
      return SizedBox(
        width: screenWidth * x,
        height: screenHeight * y,
        child: ElevatedButton(
          style: globals.style1,
          onPressed: () => setState(() {
            launched = openUrl(Uri.parse(url));
          }),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              Text(
                txt,
                style: const TextStyle(fontSize: 25),
              ),
              const Icon(
                Icons.arrow_forward,
                size: 25,
              ),
            ],
          ),
        ),
      );
    }

    SizedBox spacing(double y) {
      return SizedBox(height: screenHeight * y);
    }

    getVersion();

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: globals.appBarColor,
          title: const Text('About Us'),
          centerTitle: true,
        ),
        body: Container(
          color: globals.backgroundColor,
          width: screenWidth,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                spacing(0.01),
                Text(
                  '© 2020-24 Astro Gen-Z',
                  style: TextStyle(fontSize: 18, color: globals.textColor),
                ),
                Text(
                  'Calculator v${globals.version}',
                  style: TextStyle(fontSize: 25, color: globals.textColor),
                ),
                spacing(0.01),
                webButton("https://astrogenz.wixsite.com/astrogenz", "Website",
                    const Icon(Icons.language, size: 25)),
                webButton("https://astrogenz.wixsite.com/astrogenz/policy",
                    "Privacy", const Icon(Icons.policy, size: 25)),
                webButton("https://astrogenz.wixsite.com/astrogenz/credits",
                    "Credits", const Icon(Icons.copyright, size: 25)),
                webButton("https://astrogenz.wixsite.com/astrogenz/contact",
                    "Contact", const Icon(Icons.email, size: 25)),
                webButton(
                    "https://youtube.com/@astrogen-z",
                    "YouTube",
                    const ImageIcon(AssetImage("assets/youtube.png"),
                        size: 23)),
                webButton(
                    "https://play.google.com/store/apps/dev?id=9125981999068904156",
                    "Play Store",
                    const ImageIcon(AssetImage("assets/googleplay.png"),
                        size: 21)),
                spacing(0.01),
              ],
            ),
          ),
        ));
  }
}
