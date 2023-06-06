# Sentiment Analyzer

Hey there, friend! This is the Sentiment Analyzer. I designed it with a touch of warmth to make it more human-friendly. It's an application that allows users to analyze the sentiment of any text input — showing you whether the text is generally positive, negative, or neutral. This application runs as a web app, and it's powered by Python's Flask framework on the backend and Tailwind CSS for the frontend. Let's get started on how to set this up.

## Features

- **Easy Input:** Just type in or paste any text you want to analyze.
- **Instant Analysis:** Click the "Analyze" button, and get your results right away!
- **Reset Function:** Want to try with different text? No problem, just hit the "Reset" button.

## Getting Started

To get a local copy up and running, follow these simple steps:

1. Clone the repository:

```
git clone https://github.com/johncarmack/sentiment-analyzer.git
cd sentiment-analyzer
```

2. Install Python. If you're not sure how, you can check [this guide](https://python.land/installing-python) for instructions.

3. Install the project dependencies and start your virtual environment:

```
pip install -r requirements.txt
python -m venv venv
source venv/bin/activate
```

4. Run the app:

```
flask run
```

Then, open up your web browser and navigate to `http://localhost:5000/`.

## Deployment

This app is ready to be deployed using Zappa, a serverless framework for Python. The app is configured to be deployed on AWS via the zappa_settings.json file. Remember to replace the placeholders with your AWS details.

To deploy the app, you just need to run:

```
zappa deploy dev
```

or:

```
zappa deploy production
```

depending on the environment you wish to deploy.

For more information about Zappa, check [their documentation](https://zappa.readthedocs.io/en/latest/).

## GitHub Actions

The `.github/workflows/zappa.yml` file sets up a GitHub Actions workflow for continuous integration and deployment. Whenever you push to the main branch, your application will be deployed to AWS automatically.

## Future Improvements

Like all projects, this is a work in progress. Here are some enhancements that could be made:

- Allow the analysis of more complex forms of text, like documents or URLs.
- Improve the interface for a more immersive user experience.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page](https://github.com/johncarmack1984/sentiment-analyzer/issues).

## Show Your Support

Give a ⭐️ if you like this project!

Thank you so much for taking the time to read this. I hope you find it useful and I'm looking forward to hearing your feedback!

Warm regards,  
John
