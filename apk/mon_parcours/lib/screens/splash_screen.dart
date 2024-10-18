import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            // Image section
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.6, // Set height for the image section
              child: Center(
                child: Image.asset(
                  'assets/images/illustration.png',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
              ),
            ),
            const Spacer(),
            Container(
              height:
                  MediaQuery.of(context).size.height * 0.4, // Adjusted height
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    """Bienvenue sur AcadémiaVision !""",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MediaQuery.of(context).size.width *
                          0.07, // Dynamic font size based on screen width
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      "Votre avenir académique commence ici. Un voyage de découverte vous attend...",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                      )),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/predict');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.6, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded borders
                      ),
                    ),
                    child: const Text(
                      'Suivant',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
