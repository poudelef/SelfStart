# from flask import Flask, request, jsonify

# app = Flask(__name__)

# @app.route('/upload', methods=['POST'])
# def upload_image():
#     if 'image' not in request.files:
#         return jsonify({'error': 'No image part'}), 400
    
#     image = request.files['image']
#     if image.filename == '':
#         return jsonify({'error': 'No selected image'}), 400

#     # Save the image
#     image.save(f'./uploads/{image.filename}')
#     return jsonify({'message': 'Image received successfully', 'filename': image.filename}), 200

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=50600)
