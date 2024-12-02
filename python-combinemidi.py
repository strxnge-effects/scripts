# import necessary libraries
import cmd
from mido import Message, MidiFile, MidiTrack, MetaMessage

# set up variables
mid = MidiFile()
track = MidiTrack()
mid.tracks.append(track)

# type 1 midi file: all tracks start at the same time
combinedmidi = MidiFile(type=1)

# the actual window thing
class combinemidi(cmd.Cmd):
    intro = "combine midi files"
    prompt = "combine midi>>"

    def do_combine(self, line):
        "combines 2 midi files\nsyntax: combine file1.mid file2.mid"
        
        # split the input for use
        args = line.split()

        midi1 = MidiFile(args[0])
        midi2 = MidiFile(args[1])

        if midi1.ticks_per_beat != midi2.ticks_per_beat:
            print("tempos and/or time signatures do not match.")
        else:
            # since the ticks-per-beat match, it uses the value from the first midi file
            combinedmidi.ticks_per_beat = midi1.ticks_per_beat

            # tracks from the first file + tracks from the second file = all tracks in the output
            combinedmidi.tracks = midi1.tracks + midi2.tracks
            combinedmidi.save("combined.mid")

            # letting you know it's done :)
            print("file output to \"combined.mid\"")

    def do_exit(self, line):
        "exits the program"
    
        # exits the program
        return True

if __name__ == "__main__":
     combinemidi().cmdloop()