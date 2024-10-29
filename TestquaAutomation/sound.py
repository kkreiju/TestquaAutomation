import winsound

def play_success_sound():
    winsound.PlaySound('assets/sfx.wav', winsound.SND_FILENAME)