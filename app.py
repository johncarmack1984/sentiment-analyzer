from flask import Flask, render_template, request, jsonify
from textblob import TextBlob

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/analyze', methods=['POST'])
def analyze_sentiment():
    text = request.json['text']
    blob = TextBlob(text)
    sentiment = blob.sentiment.polarity
    return jsonify({
        'sentiment': sentiment,
        'text': text
    })

if __name__ == '__main__':
    app.run(debug=True)
