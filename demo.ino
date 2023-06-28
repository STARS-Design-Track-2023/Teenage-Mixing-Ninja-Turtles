///////// NOTE: This code is generated from the Micro Python script and may not properly impliment all features of the script. Please refer to the Micro Python script for full functionality. /////////

const int C = 0;
const int Cs = 1;
const int D = 2;
const int Ds = 3;
const int E = 4;
const int F = 5;
const int Fs = 6;
const int G = 7;
const int Gs = 8;
const int A = 9;
const int As = 10;
const int B = 11;
const int Oct_up = 14;
const int Oct_down = 13;
const int r = 20;
const int mode = 15;
const int LED = 25;

int music_list[] = {400, Oct_up, E, E, r, E, r, C, E, r, G, G, r, r, Oct_down, G, G, r, r, Oct_up, C, C, r, Oct_down, G, r, r, E, E, r, A, r, B, r, As, A, A,
                    G, G, Oct_up, E, G, A, A, F, G, r, E, r, C, F, D, r, r, G, Fs, F, Ds, r, E, r, Oct_down, Gs, A, r, Oct_up, C, Oct_down, A, Oct_up, C, D, r, r,
                    G, Fs, F, Cs, r, E, r, Oct_up, C, r, C, C, r, r, r, Oct_down, G, Fs, F, Ds, r, E, r, Oct_down, Gs, A, Oct_up, C, r, Oct_down, A, Oct_up, C, D, r, r, Ds,
                    r, Ds, r, D, r, r, r, r, r, r, D, C, r, C, r, C, C, r, C, r, C, D, r, E, C, r, Oct_down, A, G, G, r, r,
                    Oct_up, C, C, r, C, r, C, D, E, r, r, r, r, r, C, C, r, C, r, C, D, r, E, C, r, Oct_down, A, G, r, r, Oct_up, E, E, r, E, r, C, E, r, G, G, r, r, Oct_down, A, A, r, r};

void reset_input(int Pins[], int pinCount, int octave_up, int octave_down)
{
    for (int i = 0; i < pinCount; i++)
    {
        pinMode(Pins[i], OUTPUT);
        digitalWrite(Pins[i], LOW);
    }
    digitalWrite(octave_up, HIGH);
    delay(10);
    digitalWrite(octave_up, LOW);
    delay(10);
    digitalWrite(octave_up, HIGH);
    delay(10);
    digitalWrite(octave_up, LOW);
    delay(10);
    digitalWrite(octave_down, HIGH);
    delay(10);
    digitalWrite(octave_down, LOW);
    delay(10);
}

void push_btn(int pin)
{
    digitalWrite(pin, HIGH);
    delay(10);
    digitalWrite(pin, LOW);
    delay(10);
}

void play_note(int note, int BPM = 155)
{
    float BPS = 60.0 / BPM;
    digitalWrite(note, HIGH);
    delay(BPS * 1000);
    digitalWrite(note, LOW);
}

void play_music(int music[], int note_pin, int octave_up, int octave_down, int BPM = 155)
{
    int note;
    for (int i = 0; i < sizeof(music) / sizeof(music[0]); i++)
    {
        note = music[i];
        if (note == Oct_up)
        {
            push_btn(octave_up);
        }
        else if (note == Oct_down)
        {
            push_btn(octave_down);
        }
        else if (note == r)
        {
            delay(BPM * 2);
        }
        else
        {
            play_note(note_pin + note, BPM);
        }
        delay(BPM / 2);
    }
}

void setup()
{
    int Pins[] = {C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B};
    int pinCount = sizeof(Pins) / sizeof(Pins[0]);
    pinMode(LED, OUTPUT);
    reset_input(Pins, pinCount, Oct_up, Oct_down);
}

void loop()
{
    digitalWrite(LED, HIGH);
    play_music(music_list, C, Oct_up, Oct_down, 155);
    digitalWrite(LED, LOW);
    delay(5000);
}