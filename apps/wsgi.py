from flask import Flask, request, jsonify
from flask_restx import Api, Resource, fields
import joblib
import pandas as pd
import numpy as np

app = Flask(__name__)
api = Api(app, version='1.0', title='Option Classification API',
        description='Un service de classification des options pour les élèves basé sur leurs notes et leur situation personnelle.')


# Charger les modèles
model = joblib.load('option_classification_final.pkl')
encoders = joblib.load('encoders.pkl')


# Définir le modèle de prédiction pour Swagger
prediction_model = api.model('PredictionModel', {
    'sexe': fields.String(required=True, description='Sexe de l\'élève (M/F)'),
    'nb frère': fields.Integer(required=True, description='Nombre de frères'),
    'nb sœur': fields.Integer(required=True, description='Nombre de sœurs'),
    'commune d\'origine': fields.String(required=True, description='Commune d\'origine'),
    'Habite avec les parents': fields.String(required=True, description='Habite avec les parents (Oui/Non)'),
    'electricité': fields.String(required=True, description='Électricité (Oui/Non)'),
    'conn sur les options': fields.String(required=True, description='Connaissance des options (Oui/Non)'),
    'MLG': fields.Float(required=True, description='Note MLG'),
    'FRS': fields.Float(required=True, description='Note FRS'),
    'ANG': fields.Float(required=True, description='Note ANG'),
    'HG': fields.Float(required=True, description='Note HG'),
    'SES': fields.Float(required=True, description='Note SES'),
    'MATHS': fields.Float(required=True, description='Note MATHS'),
    'PC': fields.Float(required=True, description='Note PC'),
    'SVT': fields.Float(required=True, description='Note SVT'),
    'EPS': fields.Float(required=True, description='Note EPS'),
    '1°S': fields.Float(required=True, description='Note 1°S'),
    '2°S': fields.Float(required=True, description='Note 2°S'),
    'MOY AN': fields.Float(required=True, description='Moyenne annuelle')
})


# Endpoint de prédiction
@api.route('/predict')
@api.doc(description="Endpoint pour classifier l'option d'un élève basé sur ses notes et son profil personnel")
class Predict(Resource):
    @api.expect(prediction_model)
    @api.doc(summary='Prédire l\'option d\'un élève', description="Ce service permet de prédire l'option scolaire d'un élève en fonction de ses résultats et de sa situation.")
    def post(self):
        # Récupérer les données envoyées par la requête
        data = request.json

        # Convertir en DataFrame pour appliquer l'encodage
        input_data_df = pd.DataFrame([data])

        # Encodage des variables catégorielles
        cols_to_encode = ['sexe', 'commune d\'origine', 'Habite avec les parents', 'electricité', 'conn sur les options']
        for col in cols_to_encode:
            input_data_df[col] = encoders[col].transform(input_data_df[col])
            
        # Transformer les données en tableau numpy
        input_array = np.array(input_data_df)

        # Faire la prédiction avec le modèle chargé
        prediction = model.predict(input_array)
        decoded_prediction = encoders['Opt'].inverse_transform(prediction)
        
        # Retourner la prédiction sous forme de JSON
        return jsonify({'prediction': str(decoded_prediction[0])})

def configure_cors(app):
    from flask_cors import CORS

    CORS(app,supports_credentials=True)

# Démarrer l'application Flask
if __name__ == '__main__':
    configure_cors(app)
    app.run(debug=True,host="0.0.0.0")
