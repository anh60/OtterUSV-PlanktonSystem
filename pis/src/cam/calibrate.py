import base64

def calibrate():
    print("Calibration started\n")

    with open("image.jpg", "rb") as image:
        img = image.read()
    
    message = img 
    base64_bytes = base64.b64encode(message)
    base64_message = base64_bytes.decode('ascii')

    client.pub_photo(base64_message)

    print("Calibration finished\n")
    state.set_sys_state(state.status_flag.CALIBRATING, 0)

    if((state.get_sys_state() >> state.status_flag.CALIBRATING) & 1):
        calibrate()