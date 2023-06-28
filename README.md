# STARS 2023 Design Final Project

<p align="center">
<img src=https://cdn.discordapp.com/attachments/1118551461463343174/1123393538084831252/Team_Logo_1.png />
</p>

## Teenage Mixing Ninja Turtles
* Eli Jorgensen
* Uriel Orpilla
* Kurt Riegl
* Ethan Baird
* Htet Yan

## Polyphonic Synthesizer
The polyphonic synthesizer will take up to 12 button inputs ([see Pin Layout](#pin-layout)) that each represent one of the notes: C, C#, D, D#, E, F, F#, G, G#, A, A#, and B. The device will allow for both individual and groups of notes to be played. While any number of notes can be played together, the design is optimized for up to 4 buttons to avoid clipping of the expected PWM. 

Besides the note inputs, the synthesizer has 4 other buttons ([see Pin Layout](#pin-layout)): 1 reset button, 1 mode button, and 2 octave control buttons. The reset button will reinitialize the system by zeroing all counters and setting the octave state to the middle octave. The mode button will cause the wavegenerator to produce either no output, square, triangle, or sawtooth based on the given mode state. The modes cycle from OFF->square->triangle->sawtooth->OFF. One octave button will cause the buttons to be mapped to notes one octave higher, while the other will cause the notes to be mapped to one octave lower relative to the current octave. 

A total of 5 octaves can be can be chosen with the middle octave representing middle C to B. The user can go 2 octaves above and below the middle C scale. The 5 octaves can be found in a 61-key keyboard; however, the current design supports up to 60 as only 12 notes are included per octave. With a range of 60 notes, most songs can be played, but any notes that are played together must be within the same octave. 

Since a PWM signal will be produced as the output, a low-pass filter will be required to convert the signal into an analog variant that can be passed through a speaker, which will produce the desired tones. The bandwidth of the filter will need to be greater than about 2.1kHz since the highest note that can be played has a frequency of about 2.05kHz. If a commercial speaker (or some other audio device) is used then the above can be ignored since most modern audio devices have some form of a digital audio converter with a very high sampling rate.

## Pin Layout
GPIO 0: Reset Button  
GPIO 1-12: Notes Input Buttons   
GPIO 13: Octave Down Button  
GPIO 14: Octave Up Button  
GPIO 15: Mode Button    
GPIO 16: PWM Output  
GPIO 17-18: Mode LED Output  

## Supporting Equipment
Ideally the user should connect 16 buttons to the respective inputs ([see Pin Layout](#pin-layout)) so the synth can be properly controlled. It is recommended that the buttons have clear designations by color or text to avoid confusion. The buttons may fluctuate and cause unexpected errors, so pull down resistors and debouncing capacitors should be integrated with each button (see image below for example circuit). The PWM output pin should be connected to an audio jack, which can then be routed through a speaker or headphones to hear the sounds produced by the synthesizer. 

The output LEDs will show the mode of the synth. When no LEDs are on, the synth is in the OFF mode and will not output a PWM. When the right LED (from GPIO 18) is on by itself, the synth will output a square wave. When the left LED (from GPIO 17) is on, the synth will output a triangle wave. When both LEDs are on, the synth will output a sawtooth wave.

Although not required, a microcontroller can be added to the synth to control the button inputs with a much smaller delay than is possible by manual input. When the design is connected to a microcontroller, the design can function similar to a real person playing a piano because octave changes can occur very rapidly within just a few clock cycles. A Raspberry Pi Pico was successfully tested under this theory and was able to take a song input and produce an output that nearly resembled the original pieces, while also matching the necessary BPM.

## RTL Diagrams
Overall Synth RTL  
<p align="center">  
<img src=docs/synth.png />
</p>

Keypad Wavedrom  
<p align="center">
<img src=docs/keypad_wave.png />
</p>

Mode Selection RTL  
<p align="center">
<img src=docs/mode_rtl.png />
</p>

Mode Selection FSM  
<p align="center">
<img src=docs/mode_select.drawio.png />
</p>

Octave Control RTL  
<p align="center">
<img src=docs/octave_control.png />
</p>

Clock Divider RTL  
<p align="center">
<img src=docs/clock_divider.drawio.png />
</p>

Clock Divider Wavedrom  
<p align="center">
<img src=docs/clock_wavedrom.png />
</p>

PWM RTL  
<p align="center">
<img src=docs/pwm_rtl.png />
</p>

PWM Wavedrom  
<p align="center">
<img src=docs/PWM-wave.png />
</p>

## Some Legal Statement
From Purdue that I haven't figured out yet, maybe some stuff about Dr. J, the program, and other instructors
