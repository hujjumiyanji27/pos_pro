import serial
import threading
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

caller_id = None

def listen_serial():
    global caller_id
    try:
        ser = serial.Serial('COM3', 9600, timeout=1)  # use COM3 as shown in your screenshot
        while True:
            line = ser.readline().decode(errors='ignore').strip()
            if "NMBR=" in line:
                caller_id = line.split("NMBR=")[1].strip()
    except serial.SerialException as e:
        print("Serial error:", e)

@app.route('/caller_id')
def get_caller_id():
    return jsonify({'number': caller_id})

if __name__ == '__main__':
    threading.Thread(target=listen_serial, daemon=True).start()
    app.run(host='0.0.0.0', port=5000)
