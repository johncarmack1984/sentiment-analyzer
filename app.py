import os
from flask import Flask, render_template, request, jsonify, send_from_directory
from textblob import TextBlob

app = Flask(__name__)


@app.route('/')
def home():
    return render_template('index.html')


@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')


@app.route('/analyze', methods=['POST'])
def analyze_sentiment():
    text = request.json['text']
    blob = TextBlob(text)
    sentiment = blob.sentiment.polarity
    response = jsonify({
        'sentiment': sentiment,
        'text': text
    })
    return response


if __name__ == '__main__':
    app.run(debug=True)
