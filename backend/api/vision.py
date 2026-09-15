import cv2

from fastapi import APIRouter, UploadFile, File

from services.yolo_service import detect_objects
from services.decision_engine import analyze_situation
from services.tts_service import text_to_speech
from services.distance_position_service import add_position_and_distance


router = APIRouter(
    prefix="/vision",
    tags=["Vision"]
)


# ========================================
# VISION TEST
# ========================================

@router.get("/test")
def vision_test():

    return {
        "status": "success",
        "message": "Vision API is working"
    }


# ========================================
# VISION ANALYZE
# ========================================

@router.post("/analyze")
async def vision_analyze(
    file: UploadFile = File(...)
):

    # ------------------------------------
    # Save uploaded image
    # ------------------------------------

    image_data = await file.read()

    image_path = "vision_image.jpg"

    with open(image_path, "wb") as f:
        f.write(image_data)


    # ------------------------------------
    # YOLO OBJECT DETECTION
    # ------------------------------------

    detection_result = detect_objects(
        image_path
    )

    objects = detection_result.get(
        "objects",
        []
    )


    # ------------------------------------
    # DISTANCE + POSITION
    # ------------------------------------

    if objects:

        frame = cv2.imread(
            image_path
        )

        objects = add_position_and_distance(
            frame,
            objects
        )


    # ------------------------------------
    # DECISION ENGINE
    # ------------------------------------

    decision = analyze_situation(
        objects
    )


    # ------------------------------------
    # TEXT TO SPEECH
    # ------------------------------------

    speech_result = text_to_speech(
        decision["message"]
    )


    # ------------------------------------
    # FINAL RESPONSE
    # ------------------------------------

    return {

        "objects": objects,

        "status": decision["status"],

        "message": decision["message"],

        "recommended_direction":
            decision["recommended_direction"],

        "speech":
            speech_result["message"]

    }