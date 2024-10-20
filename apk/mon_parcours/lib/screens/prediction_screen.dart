import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'result_screen.dart';
import 'package:mon_parcours/constant/constant.dart';

class Predict extends StatefulWidget {
  const Predict({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PredictState createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _familialFormKey = GlobalKey<FormState>();
  String? sexe = 'M';
  bool habiteAvecParents = true;
  bool electricite = true;
  bool connSurOptions = true;
  String? commune = 'Fianarantsoa';
  int _currentStep = 0;

  // Contrôleurs pour les champs de texte
  final Map<String, TextEditingController> controllers = {
    "nbFrere": TextEditingController(),
    "nbSoeur": TextEditingController(),
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
    "moyenAnnuel": TextEditingController(),
  };

  // Fonction pour simuler l'envoi des données
  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 4));
    sendData(); // Envoie les données au backend
  }

  Future<void> sendData() async {
    const url =
        'http://109.199.99.66:5000/predict'; // Remplacez avec l'URL de votre backend
    final Map<String, dynamic> data = {
      "sexe": sexe,
      "nb frère": int.parse(controllers["nbFrere"]!.text),
      "nb sœur": int.parse(controllers["nbSoeur"]!.text),
      "commune d'origine": commune,
      "Habite avec les parents": habiteAvecParents ? "oui" : "non",
      "electricité": electricite ? "oui" : "non",
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
      "MOY AN": double.parse(controllers["moyenAnnuel"]!.text),
    };

    try {
      Dio dio = Dio();
      final response = await dio.post(url, data: data);

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        print(response.data);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(response.data!),
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

  final List<DropdownMenuItem<String>> _dropDownMenuItems = municipality
      .map((e) => DropdownMenuItem(
            child: Text(e),
            value: e,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 20),
                    child: const Text(
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
                      padding: const EdgeInsets.only(left: 0),
                      children: [
                        Stepper(
                            type: StepperType.vertical,
                            physics: const ClampingScrollPhysics(),
                            currentStep: _currentStep,
                            onStepTapped: (int step) {
                              if (_familialFormKey.currentState!.validate()) {
                                setState(() {
                                  _currentStep = step;
                                });
                              }
                            },
                            onStepContinue: () {
                              if (_currentStep == 1 &&
                                  _formKey.currentState!.validate()) {
                                _submitForm();
                              }
                              if (_currentStep == 0 &&
                                  _familialFormKey.currentState!.validate()) {
                                setState(() {
                                  _currentStep += 1;
                                });
                              }
                            },
                            onStepCancel: () {
                              if (_currentStep > 0) {
                                setState(() {
                                  _currentStep -= 1;
                                });
                              }
                            },
                            steps: [
                              Step(
                                  title: Text("Informations personnelles",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontFamily: 'Nunito')),
                                  isActive: _currentStep == 0,
                                  state: _currentStep > 0 &&
                                          _familialFormKey.currentState!
                                              .validate()
                                      ? StepState.complete
                                      : StepState.editing,
                                  content: Column(
                                    children: [
                                      SizedBox(height: 16),
                                      DropdownButtonFormField<String>(
                                        value: commune,
                                        hint: Text("Commune d'origine"),
                                        onChanged:
                                            (String? selectedMunicipality) {
                                          setState(() {
                                            if (selectedMunicipality != null) {
                                              commune = selectedMunicipality;
                                            }
                                          });
                                        },
                                        items: _dropDownMenuItems,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 10.0),
                                          labelText: "Commune d'origine",
                                          labelStyle:
                                              TextStyle(color: Colors.blueGrey),
                                        ),
                                      ),
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
                                      Form(
                                          key: _familialFormKey,
                                          child: Column(
                                            children: [
                                              buildFamilialField(
                                                  label: 'Nombre de frères',
                                                  controller:
                                                      controllers["nbFrere"]!),
                                              buildFamilialField(
                                                  label: 'Nombre de sœurs',
                                                  controller:
                                                      controllers["nbSoeur"]!)
                                            ],
                                          )),
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
                                    ],
                                  )),
                              Step(
                                title: Text('Notes scolaires',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontFamily: 'Nunito')),
                                isActive: _currentStep == 1,
                                state: _currentStep == 1
                                    ? StepState.editing
                                    : StepState.indexed,
                                content: Form(
                                    key: _formKey,
                                    child: Column(children: [
                                      buildTextField(
                                          label: 'MLG',
                                          controller: controllers["mlg"]!),
                                      buildTextField(
                                          label: 'FRS',
                                          controller: controllers["frs"]!),
                                      buildTextField(
                                          label: 'ANG',
                                          controller: controllers["ang"]!),
                                      buildTextField(
                                          label: 'HG',
                                          controller: controllers["hg"]!),
                                      buildTextField(
                                          label: 'SES',
                                          controller: controllers["ses"]!),
                                      buildTextField(
                                          label: 'Maths',
                                          controller: controllers["maths"]!),
                                      buildTextField(
                                          label: 'PC',
                                          controller: controllers["pc"]!),
                                      buildTextField(
                                          label: 'SVT',
                                          controller: controllers["svt"]!),
                                      buildTextField(
                                          label: 'EPS',
                                          controller: controllers["eps"]!),
                                      buildTextField(
                                          label: '1°S',
                                          controller: controllers["premierS"]!,
                                          mean: true),
                                      buildTextField(
                                          label: '2°S',
                                          controller: controllers["deuxiemeS"]!,
                                          mean: true),
                                      buildTextField(
                                          label: 'Moyenne annuelle',
                                          controller:
                                              controllers["moyenAnnuel"]!,
                                          mean: true),
                                    ])),
                              )
                            ])
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildTextField(
      {required String label,
      required TextEditingController controller,
      bool mean = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            focusColor: Colors.teal,
            labelText: label,
            fillColor: Colors.teal[100],
            hintStyle: TextStyle(color: Colors.grey[50]),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "veuillez inserer votre note $label";
            }
            if (!mean &&
                (double.parse(value) < 0 || double.parse(value) > 40)) {
              return "Votre note doit être compris entre 0 à 40";
            }
            if (mean && (double.parse(value) < 0 || double.parse(value) > 20)) {
              return "Votre moyenne doit être compris entre 0 à 20";
            }
            return null;
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildFamilialField(
      {required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            focusColor: Colors.teal,
            labelText: label,
            fillColor: Colors.teal[100],
            hintStyle: TextStyle(color: Colors.grey[50]),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "veuillez inserer le nombre de votre $label";
            }
            if (double.parse(value) < 0 || double.parse(value) > 20) {
              return "Veuillez remplir en bonne et du forme cette champs";
            }
            return null;
          },
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
