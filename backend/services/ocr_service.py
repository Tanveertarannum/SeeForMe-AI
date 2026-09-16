import warnings
warnings.filterwarnings("ignore")

import easyocr
import cv2


# Initialize EasyOCR
reader = easyocr.Reader(
    ['en'],
    gpu=False,
    verbose=False
)


def read_text(image_path):

    # Read image
    image = cv2.imread(image_path)

    if image is None:
        return {
            "text": "",
            "message": "Unable to read image."
        }

    # Run EasyOCR
    results = reader.readtext(image)

    detected_text = []

    for result in results:

        text = result[1]
        confidence = result[2]

        # Confidence threshold
        if confidence >= 0.40:
            detected_text.append(text)

    # Combine detected text
    text = "\n".join(detected_text)

    if text:
        message = "Text detected successfully."
    else:
        message = "No text detected."

    return {
        "text": text,
        "message": message
    }