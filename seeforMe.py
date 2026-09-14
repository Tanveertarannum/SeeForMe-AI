import cv2
from ultralytics import YOLO


# ============================================================
# SeeForMe - Member 2
# Computer Vision / Object Detection Module
# ============================================================


# ------------------------------------------------------------
# SETTINGS
# ------------------------------------------------------------

MODEL_PATH = "yolov8s-worldv2.pt"

# Higher confidence = fewer false detections
CONFIDENCE = 0.40


# ------------------------------------------------------------
# PRIORITY OBJECTS
# ------------------------------------------------------------

HIGH_PRIORITY = {
    "person",
    "bicycle",
    "car",
    "motorcycle",
    "bus",
    "truck",
    "traffic light",
    "stop sign"
}


MEDIUM_PRIORITY = {
    "chair",
    "couch",
    "bed",
    "dining table",
    "table",
    "backpack",
    "suitcase",
    "dog",
    "cat",
    "cell phone",
    "book",
    "box"
}


# ------------------------------------------------------------
# LOAD YOLO-WORLD MODEL
# ------------------------------------------------------------

print("Loading YOLO-World model...")

model = YOLO(MODEL_PATH)

print("Model loaded successfully!")


# ------------------------------------------------------------
# SET OBJECT CLASSES
# ------------------------------------------------------------

OBJECT_CLASSES = [
    "person",
    "car",
    "bicycle",
    "motorcycle",
    "bus",
    "truck",
    "chair",
    "dining table",
    "table",
    "book",
    "cell phone",
    "backpack",
    "suitcase",
    "dog",
    "cat",
    "door",
    "stairs",
    "box"
]

model.set_classes(OBJECT_CLASSES)


# ============================================================
# DETECT OBJECTS FUNCTION
# ============================================================

def detect_objects(frame):

    height, width, _ = frame.shape

    # Divide camera into left / center / right
    left_boundary = width // 3
    right_boundary = (width * 2) // 3

    # Run YOLO detection
    results = model(
        frame,
        conf=CONFIDENCE,
        verbose=False
    )

    detections = []

    for result in results:

        if result.boxes is None:
            continue

        for box in result.boxes:

            class_id = int(box.cls[0])

            object_name = model.names[class_id]

            confidence = float(box.conf[0])

            x1, y1, x2, y2 = map(
                int,
                box.xyxy[0]
            )


            # ------------------------------------------------
            # OBJECT CENTER
            # ------------------------------------------------

            center_x = (x1 + x2) // 2
            center_y = (y1 + y2) // 2


            # ------------------------------------------------
            # DETERMINE POSITION
            # ------------------------------------------------

            if center_x < left_boundary:
                position = "left"

            elif center_x > right_boundary:
                position = "right"

            else:
                position = "center"


            # ------------------------------------------------
            # DETERMINE PRIORITY
            # ------------------------------------------------

            if object_name in HIGH_PRIORITY:
                priority = "high"

            elif object_name in MEDIUM_PRIORITY:
                priority = "medium"

            else:
                priority = "low"


            # ------------------------------------------------
            # CREATE DETECTION DATA
            # ------------------------------------------------

            detection = {
                "object": object_name,
                "confidence": round(confidence, 2),
                "bbox": [x1, y1, x2, y2],
                "center_x": center_x,
                "center_y": center_y,
                "position": position,
                "priority": priority
            }

            detections.append(detection)


    return detections


# ============================================================
# CAMERA TEST PROGRAM
# ============================================================

if __name__ == "__main__":

    print()
    print("========================================")
    print("       SeeForMe Object Detection")
    print("             Member 2")
    print("========================================")
    print()

    print("Starting camera...")

    cap = cv2.VideoCapture(0)


    # --------------------------------------------------------
    # CHECK CAMERA
    # --------------------------------------------------------

    if not cap.isOpened():

        print("ERROR: Camera could not be opened.")

        input("Press Enter to exit...")

        raise SystemExit


    print("Camera started successfully!")
    print("Press Q to quit.")


    # ========================================================
    # CAMERA LOOP
    # ========================================================

    while True:

        success, frame = cap.read()

        if not success:
            break


        # ----------------------------------------------------
        # DETECT OBJECTS
        # ----------------------------------------------------

        detections = detect_objects(frame)


        height, width, _ = frame.shape

        left_boundary = width // 3
        right_boundary = (width * 2) // 3


        # ----------------------------------------------------
        # DRAW DETECTIONS
        # ----------------------------------------------------

        for detection in detections:

            x1, y1, x2, y2 = detection["bbox"]

            object_name = detection["object"]

            confidence = detection["confidence"]

            position = detection["position"]


            # Draw bounding box

            cv2.rectangle(
                frame,
                (x1, y1),
                (x2, y2),
                (0, 255, 0),
                2
            )


            # Detection label

            label = (
                f"{object_name} "
                f"{confidence:.0%} "
                f"[{position}]"
            )


            cv2.putText(
                frame,
                label,
                (x1, max(y1 - 10, 25)),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.6,
                (0, 255, 0),
                2
            )


        # ----------------------------------------------------
        # DRAW POSITION LINES
        # ----------------------------------------------------

        cv2.line(
            frame,
            (left_boundary, 0),
            (left_boundary, height),
            (255, 255, 255),
            1
        )

        cv2.line(
            frame,
            (right_boundary, 0),
            (right_boundary, height),
            (255, 255, 255),
            1
        )


        # ----------------------------------------------------
        # TITLE
        # ----------------------------------------------------

        cv2.putText(
            frame,
            "SeeForMe - Member 2",
            (20, height - 20),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.7,
            (255, 255, 255),
            2
        )


        # ----------------------------------------------------
        # SHOW CAMERA
        # ----------------------------------------------------

        cv2.imshow(
            "SeeForMe Object Detection",
            frame
        )


        # ----------------------------------------------------
        # PRINT DETECTIONS
        # ----------------------------------------------------

        if detections:

            print()
            print("========================================")
            print("DETECTIONS")
            print("========================================")

            for detection in detections:
                print(detection)


        # ----------------------------------------------------
        # PRESS Q TO QUIT
        # ----------------------------------------------------

        if cv2.waitKey(1) & 0xFF == ord("q"):
            break


    # ========================================================
    # CLEANUP
    # ========================================================

    cap.release()

    cv2.destroyAllWindows()

    print()
    print("========================================")
    print("SeeForMe Object Detection stopped.")
    print("========================================")