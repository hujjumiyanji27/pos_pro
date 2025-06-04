from flask import Flask, jsonify
from flask_cors import CORS
import time

app = Flask(__name__)
CORS(app)

# Simulated caller ID
current_number = None
last_time = time.time()

@app.route('/caller_id')
def get_caller_id():
    global last_time
    global current_number

    # Reset number every 15 seconds for demo
    if time.time() - last_time > 15:
        current_number = None

    return jsonify({'number': current_number})

# To simulate incoming call manually via browser
@app.route('/simulate/<number>')
def simulate_number(number):
    global current_number
    global last_time
    current_number = number
    last_time = time.time()
    return jsonify({'success': True, 'number': current_number})

if __name__ == '__main__':
    app.run(host='localhost', port=5000)
