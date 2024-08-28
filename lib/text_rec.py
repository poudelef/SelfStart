# # Step 1: Install necessary libraries
# # !pip install opencv-python-headless pytesseract
# # !pip install flask
# from flask import Flask, jsonify, request
# import cv2

# app = Flask(__name__)

# @app.route('/capture_image', methods=['GET'])
# def capture_image():
#     cap = cv2.VideoCapture(0)
#     ret, frame = cap.read()
#     if ret:
#         cv2.imwrite('captured_image.png', frame)
#         cap.release()
#         return jsonify({"message": "Image captured successfully", "image_path": "captured_image.png"})
#     else:
#         cap.release()
#         return jsonify({"message": "Failed to capture image"}), 500

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000)

# import cv2
# import pytesseract
# import re
# from datetime import datetime

# # Step 2: Capture an image from the webcam
# def capture_image():
#     cap = cv2.VideoCapture(0)
#     ret, frame = cap.read()
#     if ret:
#         cv2.imwrite('captured_image.png', frame)
#     cap.release()
#     return 'captured_image.png'

# # Step 3: Process the image to extract text
# def extract_text(image_path):
#     img = cv2.imread(image_path)
#     if img is None:
#         raise ValueError(f"Image not found or unsupported format: {image_path}")
#     text = pytesseract.image_to_string(img)
#     return text

# # Step 4: Extract the date from the text
# def extract_date(text):
#     date_pattern = r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b'
#     match = re.search(date_pattern, text)
#     if match:
#         date_str = match.group()
#         try:
#             date_obj = datetime.strptime(date_str, '%d/%m/%Y')
#         except ValueError:
#             date_obj = datetime.strptime(date_str, '%m/%d/%Y')
#         return date_obj.strftime('%Y-%m-%d')
#     return None

# # Step 5: Save the extracted date to a file
# def save_date(date):
#     with open('extracted_date.txt', 'w') as file:
#         file.write(f'Extracted Date: {date}')

# # Main function to run the steps
# def main():
#     image_path = capture_image()
#     text = extract_text(image_path)
#     date = extract_date(text)
#     if date:
#         save_date(date)
#         print(f'Date extracted and saved: {date}')
#     else:
#         print('No date found in the image.')

# # Run the main function
# main()