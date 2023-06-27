from machine import Pin
from time import sleep

# initalize pins
C = Pin(0, Pin.OUT, Pin.PULL_DOWN)
Cs = Pin(1, Pin.OUT, Pin.PULL_DOWN)
D = Pin(2, Pin.OUT, Pin.PULL_DOWN)
Ds = Pin(3, Pin.OUT, Pin.PULL_DOWN)
E = Pin(4, Pin.OUT, Pin.PULL_DOWN)
F = Pin(5, Pin.OUT, Pin.PULL_DOWN)
Fs = Pin(6, Pin.OUT, Pin.PULL_DOWN)
G = Pin(7, Pin.OUT, Pin.PULL_DOWN)
Gs = Pin(8, Pin.OUT, Pin.PULL_DOWN)
A = Pin(9, Pin.OUT, Pin.PULL_DOWN)
As = Pin(10, Pin.OUT, Pin.PULL_DOWN)
B = Pin(11, Pin.OUT, Pin.PULL_DOWN)
Oct_up = Pin(14, Pin.OUT, Pin.PULL_DOWN)
Oct_down = Pin(13, Pin.OUT, Pin.PULL_DOWN)
r = Pin(20, Pin.OUT)
mode = Pin(15, Pin.OUT, Pin.PULL_DOWN)
LED = Pin(25, Pin.OUT, Pin.PULL_DOWN)

# DOOM LIST
# music_list = [880, Oct_down,
#               Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, E, E, E, E, B, B, Oct_up, C, C, Oct_down, E, E, E, E, Oct_up, E, E,  Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, As, As, As, As, As,
#               Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, E, E, E, E, B, B, Oct_up, C, C, Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, As, As, As, As, As,
#               Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, E, E, E, E, B, B, Oct_up, C, C, Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, As, As, As, As, As,
#               Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, E, E, E, E, B, B, Oct_up, C, C, Oct_down, E, E, E, E, Oct_up, E, E,  Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, F, E, Ds, F, A, G, F, D, F, G, A, Oct_up, B, Oct_down, A, G, F, D,
#               Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, E, E, E, E, B, B, Oct_up, C, C, Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, As, As, As, As, As,
#               Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, C, C, Oct_down, E, E, E, E, As, As, E, E, E, E, B, B, Oct_up, C, C, Oct_down, E, E, E, E, Oct_up, E, E, Oct_down, E, E, E, E, Oct_up, D, D, Oct_down, E, E, E, E, Oct_up, B, Oct_down, D, G, E, G, Oct_up, B, Oct_down, G, Oct_up, B, E, B, Oct_down, G, Oct_up, B, Oct_down, G, Oct_up, B, E, G, B,
#               Oct_down, A, A, A, A, Oct_up, A, A, Oct_down, A, A, A, A, Oct_up, G, G, Oct_down, A, A, A, A, Oct_up, F, F, Oct_down, A, A, A, A, Oct_up, Ds, Ds, Oct_down, A, A, A, A, Oct_up, Ds, Ds, F, F,Oct_down, A, A, A, A, Oct_up, A, A, Oct_down, A, A, A, A, Oct_up, G, G, Oct_down, A, A, A, A, Oct_up, F, F, Oct_down, A, A, A, A, Oct_up, Ds, Ds, Oct_down, A, A, A, A, Oct_up, Ds, Ds, F, F,
#               Oct_down, A, A, A, A, Oct_up, A, A, Oct_down, A, A, A, A, Oct_up, G, G, Oct_down, A, A, A, A, Oct_up, F, F, Oct_down, A, A, A, A, Oct_up, Ds, Ds, Oct_down, A, A, A, A, Oct_up, Ds, Ds, F, F,Oct_down, A, A, A, A, Oct_up, A, A, Oct_down, A, A, A, A, Oct_up, G, G, Oct_down, A, A, A, A, Oct_up, A, F, E, A, E, C, E, A, C, A, E, A, E, A, E, C]

# Night of knights
# music_list = [720,D,D,A,A,G,A,A,E,E,F,F,A,G,F,E,D,
#                 D,D,A,A,G,A,A,E,E,F,F,A,C,C,Cs,Cs,
#                 D,D,A,A,G,A,A,E,E,F,F,A,G,F,E,D,
#                 D,D,A,A,G,A,A,E,E,F,F,A,C,C,Cs,Cs,
#                 D,D,A,A,G,A,A,E,E,F,F,A,G,F,E,D,
#                 D,D,A,A,G,A,A,E,E,F,F,A,C,C,Cs,Cs,
#                 D,D,A,A,G,A,A,E,E,F,F,A,G,F,E,D,
#                 D,D,A,A,G,A,A,Oct_up,C,C,C,Oct_down,A,A,Oct_up,E,C,
#                 D,D,A,A,G,A,A,E,E,F,F,A,G,F,E,D,
#                 D,D,A,A,G,A,A,E,E,F,F,A,C,Cs,
#                 D,D,A,A,G,A,A,E,E,F,F,A,G,F,E,D,
#                 D,D,A,A,G,A,A,E,E,F,F,A,C,C,Cs,Cs,
#                 D,D,A,A,G,A,A,E,E,F,F,A,G,F,E,D,
#                 D,D,A,A,G,A,A,E,E,F,F,A,C,C,Cs,Cs,
#                 D,D,A,A,G,A,A,E,E,F,F,A,G,F,E,D,
#                 D,D,A,A,G,A,A,Oct_up,C,C,C,Oct_down,A,A,Oct_up,F,E,D,C,
#                 Oct_down,D,D,F,F,E,F,E,E,G,G,F,F,E,F,E,C,
#                 D,D,A,A,G,A,G,A, Oct_up, C, C, Oct_down, A, A,G, G,A, A,
#                 D,D,F,F,E,F,E,E,G,G,F,F,E,F,E,C,
#                 D,D,A,A,G,A,G,A, Oct_up, Cs, Cs, Oct_down, A, A,G, G, A, A,
#                 D,D,F,F,E,F,E,E,G,G,F,F,E,F,E,C,
#                 D,D,A,A,G,A,G,A, Oct_up, C, C, Oct_down, A, A,F,F,Fs,Fs,
#                 G,G,G,G,G,G,G,G,A,A,A,A,A,A,A,A,
#                 As,As,As,As,As,As,B,B,Oct_up,C,C,C,C,C,C,C,C,C,
#                 Oct_down,D,D,F,F,E,F,E,E,G,G,F,F,E,F,E,C,
#                 D,D,A,A,G,A,G,A,Oct_up,C,C,Oct_down,A,A,G,G,A,A,
#                 D,D,F,F,E,F,E,E,G,G,F,F,E,F,E,C,
#                 D,D,A,A,G,A,G,A,Oct_up,Cs,Cs,Oct_down,A,A,G,G,A,A,
#                 D,D,F,F,E,F,E,E,G,G,F,F,E,F,E,C,
#                 D,D,A,A,G,A,G,A,Oct_up,C,C,Oct_down,A,A,F,F,Fs,Fs,
#                 G,G,G,G,G,G,G,G,A,A,G,G,F,F,E,E,
#                 D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D]
# Mario
music_list = [400, Oct_up, E, E, r, E, r, C, E, r, G, G, r, r, Oct_down, G, G, r, r, Oct_up, C, C, r, Oct_down, G, r, r, E, E, r, A, r, B, r, As, A, A,
              G, G, Oct_up, E, G, A, A, F, G, r, E, r, C, F, D, r, r, G, Fs, F, Ds, r, E, r, Oct_down, Gs, A, r, Oct_up, C, Oct_down, A, Oct_up, C, D, r, r,
              G, Fs, F, Cs, r, E, r, Oct_up, C, r, C, C, r, r, r, Oct_down, G, Fs, F, Ds, r, E, r, Oct_down, Gs, A, Oct_up, C, r, Oct_down, A, Oct_up, C, D, r, r, Ds,
              r, Ds, r, D, r, r, r, r, r, r, D, C, r, C, r, C, C, r, C, r, C, D, r, E, C, r, Oct_down, A, G, G, r, r,
              Oct_up, C, C, r, C, r, C, D, E, r, r, r, r, r, C, C, r, C, r, C, D, r, E, C, r, Oct_down, A, G, r, r, Oct_up, E, E, r, E, r, C, E, r, G, G, r, r, Oct_down, A, A, r, r]


def reset_input(Pins=[C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B], octave_up=Oct_up, octave_down=Oct_down):
    for pin in Pins:
        pin.off()
    push_btn(octave_up)
    push_btn(octave_up)
    push_btn(octave_up)
    push_btn(octave_up)
    push_btn(octave_down)
    push_btn(octave_down)


def push_btn(pin):
    pin.on()
    sleep(.01)
    pin.off()


def play_note(note, BPM=155):
    BPS = 60 / BPM
    note.on()
    sleep(BPS)
    note.off()


def change_mode(modePIN):
    modePIN.on()
    sleep(.1)
    modePIN.off()


def is_digit(num):
    num_str = str(num)
    return num_str.isdigit()


# runtime loop
play = True
while play:
    BPM = 120
    reset_input()

    for note in music_list:
        if note in [C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B, r]:
            play_note(note, BPM)
        elif note in [Oct_up, Oct_down]:
            push_btn(note)
        elif is_digit(note):
            BPM = note
    LED.toggle()
    reset_input()
    play = False
