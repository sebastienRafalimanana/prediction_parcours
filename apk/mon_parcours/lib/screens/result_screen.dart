import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ResultScreen extends StatelessWidget {
  Map<String, dynamic> result;
  // ignore: non_constant_identifier_names
  ResultScreen(this.result, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Text(
              "Félicitation de la part de AcadémiaVision ! Nous sommes ravis de vous annoncer que , selon les informations que vous avez fournies, L'option académique qui vous convient parfaitement et le serie ${result['prediction']}",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
