import cmd
from mido import Message, MidiFile, MidiTrack, MetaMessage


class combinemidi(cmd.Cmd):
    prompt = "midi-tools>>"


    def do_combine(self, line):
        """add the tracks from one midi file to another
        syntax: combine file1.mid file2.mid"""
        # todo: optional output specification
        
        args = line.split()
        midi1 = MidiFile(args[0])
        midi2 = MidiFile(args[1])

        # type 1 midi file: all tracks start at the same time
        outputmidi = MidiFile(type=1)

        if midi1.ticks_per_beat != midi2.ticks_per_beat:
            print("tempos and / or time signatures do not match.")

        else:
            # add together tracks
            outputmidi.ticks_per_beat = midi1.ticks_per_beat
            outputmidi.tracks = midi1.tracks + midi2.tracks

            # name output using 1st input
            filename = f"{args[0].split(".")[0]}-combined.mid"
            outputmidi.save(filename)
            print(f"file output to \"{filename}\"")
            return True


    def do_chordsplit(self, line):
        """split overlapping notes into separate tracks
        syntax: chordsplit file.mid"""
        # todo: optional output specification
        
        midi = MidiFile(line)
        filename = f"{line}-split.mid"
        print(filename)


    def do_append(self, line):
        """append the events of file1 to the events of file2 (works best with
        single-track files)
        syntax: append file1.mid file2.mid"""

        pass


    def do_exit(self, line):
        "exits the program"
        return True

if __name__ == "__main__":
     combinemidi().cmdloop()
