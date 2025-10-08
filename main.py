import subprocess
import json
import os
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse

app = FastAPI()

@app.put("/sync")
def sync():
    try:
        output = subprocess.check_output(
            ["bw", "sync"],
            text=True,
            env=os.environ  
        )

        return {}
    except subprocess.CalledProcessError as e:
        raise HTTPException(status_code=500, detail=f"BW CLI error: {e.output}")

@app.get("/object/item/{item_id}")
def get_item(item_id: str):
    """
    Returns Bitwarden item fields as a flat JSON object for ESO extract().
    """
    try:
        output = subprocess.check_output(
            ["bw", "get", "item", item_id],
            text=True,
            env=os.environ  # includes BW_SESSION
        )
        data = json.loads(output)
    except subprocess.CalledProcessError as e:
        raise HTTPException(status_code=500, detail=f"BW CLI error: {e.output}")
    except json.JSONDecodeError:
        raise HTTPException(status_code=500, detail="Invalid JSON from BW CLI")

    result = {}

    # Flatten fields
    for field in data.get("fields", []):
        name = field.get("name")
        value = field.get("value")
        if name and value is not None:
            result[name] = value

    # Include login info
    login = data.get("login", {})
    if login.get("username"):
        result["USERNAME"] = login["username"]
    if login.get("password"):
        result["PASSWORD"] = login["password"]

    # Optional notes
    if data.get("notes"):
        result["NOTES"] = data["notes"]

    return JSONResponse(content=result)
