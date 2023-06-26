# STARS 2023 Design Final Project

## Teenage Mixing Ninja Turtles
* Eli Jorgensen
* Uriel Orpilla
* Kurt Riegl
* Ethan Baird
* Htet Yan

## Polyphonic Synthesizer
The polyphonic synthesizer will take up to 12 button inputs that each represent one of the notes: C, C#, D, D#, E, F, F#, G, G#, A, A#, and B. The device will allow for both individual and groups of notes to be played. While any number of notes can be played together, the design is optimized for up to 4 buttons to avoid clipping of the expected PWM. 

Besides the note inputs, the synthesizer has 4 other buttons: 1 reset button, 1 mode button, and 2 octave control buttons. The reset button will reinitialize the system by zeroing all counters and setting the octave state to the middle octave. The mode button will cause the wavegenerator to produce either a triangle, square, or sawtooth wave based on the given mode state. One octave button will cause the buttons to be mapped to notes one octave higher, while the other will cause the notes to be mapped to one octave lower relative to the current octave. 

A total of 5 octaves can be can be chosen with the middle octave representing middle C to B. The user can go 2 octaves above and below the middle C scale. The 5 octaves can be found in a 61-key keyboard, so the synthesizer can create notes from most songs.

Since a PWM signal will be produced as the output, a speaker with a low-pass filter will be required to convert the signal into an analog variant that can be passed through a speaker, which will produce the desired tones. The bandwidth of the filter will need to be greater than about 2.1kHz since the highest note that can be played has a frequency of about 2.05kHz. 

## Pin Layout
Put all the GPIO pin numbers, i/o/io determination, and labels

## Supporting Equipment
List all the required equipment and upload a breadboard with the equipment set up (recommend using tinkercad circuits if possible)

## RTL Diagrams
All the stuff from the proposal goes here, obviously updated from the time you did the proposal to the final layout
Include more than just block diagrams, including sub-block diagrams, state-transition diagrams, flowcharts, and timing diagrams

## Some Legal Statement
From Purdue that I haven't figured out yet, maybe some stuff about Dr. J, the program, and other instructors
