import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'result_screen.dart';

class Predict extends StatefulWidget {
  const Predict({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PredictState createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  // Variables pour stocker les données du formulaire
  String? sexe = 'M'; // Valeur par défaut
  bool habiteAvecParents = true;
  bool electricite = true;
  bool connSurOptions = true;

  // Contrôleurs pour les champs de texte
  final Map<String, TextEditingController> controllers = {
    "nbFrere": TextEditingController(),
    "nbSoeur": TextEditingController(),
    "commune": TextEditingController(),
    "mlg": TextEditingController(),
    "frs": TextEditingController(),
    "ang": TextEditingController(),
    "hg": TextEditingController(),
    "ses": TextEditingController(),
    "maths": TextEditingController(),
    "pc": TextEditingController(),
    "svt": TextEditingController(),
    "eps": TextEditingController(),
    "premierS": TextEditingController(),
    "deuxiemeS": TextEditingController(),
  };

  // Fonction pour simuler l'envoi des données
  Future<void> _submitForm() async {
    await Future.delayed(Duration(seconds: 2));
    sendData(); // Envoie les données au backend
  }

  Future<void> sendData() async {
    const url =
        'http://votre-backend-url.com/predict'; // Remplacez avec l'URL de votre backend

    final Map<String, dynamic> data = {
      "sexe": sexe,
      "nb frère": int.parse(controllers["nbFrere"]!.text),
      "nb sœur": int.parse(controllers["nbSoeur"]!.text),
      "commune d'origine": controllers["commune"]!.text,
      "Habite avec les parents": habiteAvecParents ? "oui" : "non",
      "électricité": electricite ? "oui" : "non",
      "conn sur les options": connSurOptions ? "oui" : "non",
      "MLG": double.parse(controllers["mlg"]!.text),
      "FRS": double.parse(controllers["frs"]!.text),
      "ANG": double.parse(controllers["ang"]!.text),
      "HG": double.parse(controllers["hg"]!.text),
      "SES": double.parse(controllers["ses"]!.text),
      "MATHS": double.parse(controllers["maths"]!.text),
      "PC": double.parse(controllers["pc"]!.text),
      "SVT": double.parse(controllers["svt"]!.text),
      "EPS": double.parse(controllers["eps"]!.text),
      "1°S": double.parse(controllers["premierS"]!.text),
      "2°S": double.parse(controllers["deuxiemeS"]!.text),
    };

    try {
      // Création d'une instance de Dio
      Dio dio = Dio();
      final response = await dio.post(url, data: data);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(/* passez ici les données nécessaires */),
          ),
        );
      } else {
        print('Erreur lors de l\'envoi des données : ${response.statusCode}');
      }
    } catch (e) {
      print('Exception : $e');
    }
  }

  // Fonction pour créer les boutons radio
  Widget buildRadioGroup({
    required String labelText,
    required List<String> options,
    required String? groupValue,
    required Function(String?) onChanged,
    required Map<String, Color> colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(labelText,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito')),
        ...options.map((option) {
          return ListTile(
            title: Text(option),
            leading: Radio<String>(
              value: option,
              groupValue: groupValue,
              activeColor: colors[option],
              onChanged: onChanged,
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 20),
              child: Text(
                'Vous êtes presque là,\nvotre avenir est à vos portes!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Text('Informations personnelles',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontFamily: 'Nunito')),
                  Divider(),
                  buildRadioGroup(
                    labelText: 'Sexe:',
                    options: ['M', 'F'],
                    groupValue: sexe,
                    colors: {
                      'M': Colors.teal,
                      'F': Colors.teal,
                    },
                    onChanged: (value) {
                      setState(() {
                        sexe = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  buildTextField(
                      label: 'Nombre de frères',
                      controller: controllers["nbFrere"]!),
                  buildTextField(
                      label: 'Nombre de sœurs',
                      controller: controllers["nbSoeur"]!),
                  buildTextField(
                      label: 'Commune d\'origine',
                      controller: controllers["commune"]!),
                  buildSwitchTile(
                      label: 'Habite avec les parents',
                      value: habiteAvecParents,
                      onChanged: (value) {
                        setState(() {
                          habiteAvecParents = value;
                        });
                      }),
                  buildSwitchTile(
                      label: 'Électricité disponible',
                      value: electricite,
                      onChanged: (value) {
                        setState(() {
                          electricite = value;
                        });
                      }),
                  buildSwitchTile(
                      label: 'Connaissance sur les options',
                      value: connSurOptions,
                      onChanged: (value) {
                        setState(() {
                          connSurOptions = value;
                        });
                      }),
                  const SizedBox(height: 16),
                  Text('Notes scolaires',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontFamily: 'Nunito')),
                  Divider(),
                  buildTextField(label: 'MLG', controller: controllers["mlg"]!),
                  buildTextField(label: 'FRS', controller: controllers["frs"]!),
                  buildTextField(label: 'ANG', controller: controllers["ang"]!),
                  buildTextField(label: 'HG', controller: controllers["hg"]!),
                  buildTextField(label: 'SES', controller: controllers["ses"]!),
                  buildTextField(
                      label: 'Maths', controller: controllers["maths"]!),
                  buildTextField(label: 'PC', controller: controllers["pc"]!),
                  buildTextField(label: 'SVT', controller: controllers["svt"]!),
                  buildTextField(label: 'EPS', controller: controllers["eps"]!),
                  buildTextField(
                      label: '1°S', controller: controllers["premierS"]!),
                  buildTextField(
                      label: '2°S', controller: controllers["deuxiemeS"]!),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.6, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded borders
                      ),
                    ),
                    child: const Text(
                      'Soumettre',
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

  Widget buildTextField(
      {required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            focusColor: Colors.teal,
            labelText: label,
            fillColor: Colors.teal[100],
            hintStyle: TextStyle(color: Colors.grey[50]),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildSwitchTile(
      {required String label,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(value: value, onChanged: onChanged, activeColor: Colors.teal),
      ],
    );
  }
}
