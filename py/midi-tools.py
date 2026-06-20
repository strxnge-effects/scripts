import cmd
from mido import Message, MidiFile, MidiTrack, MetaMessage


class midiTools(cmd.Cmd):
    prompt = "midi-tools>>"

    def save_file(self, filename, outputmidi):
        outputmidi.save(filename)
        print(f"saved to {filename}")

    def do_combine(self, line):
        """add the tracks from one midi file to another
        syntax: combine file1.mid file2.mid"""
        # todo: optional output specification
        
        args = line.split()
        midi1 = MidiFile(args[0])
        midi2 = MidiFile(args[1])

        if midi1.ticks_per_beat != midi2.ticks_per_beat:
            print("warning: tempos and / or time signatures do not match.\ninformation from the first file will be used.")

        try:
            # type 1 midi file: all tracks start at the same time
            outputmidi = MidiFile(type=1)
            
            # add together tracks
            outputmidi.ticks_per_beat = midi1.ticks_per_beat
            outputmidi.tracks = midi1.tracks + midi2.tracks

            self.save_file(f"{args[0].split(".")[0]}-combined.mid", outputmidi)
        except Exception as e:
            print(e)

    def do_chordsplit(self, line):
        """split overlapping notes into separate tracks
        syntax: chordsplit file.mid"""
        # todo: optional output specification
        
        midi = MidiFile(line)

        try:
            for track in midi.tracks:
                for i, msg in enumerate(track):
                    nextmsg = track[i + 1]
                    
                    if msg.type == "note_on" and nextmsg.type == "note_on":
                        print(msg.note)

            outputmidi = MidiFile(type=1)
            outputmidi.ticks_per_beat = midi.ticks_per_beat

            # self.save_file(f"{line.split(".")[0]}-split.mid", outputmidi)
        except Exception as e:
            print(e)

    def do_append(self, line):
        """append the events of file1 to the events of file2 (recommended only
        for single-track files)
        syntax: append file1.mid file2.mid"""
        # todo: optional output specification
        
        args = line.split()
        midi1 = MidiFile(args[0])
        midi2 = MidiFile(args[1])

        try:
            outputmidi = MidiFile(type=1)
            outputmidi.ticks_per_beat = midi1.ticks_per_beat

            for track1 in midi1.tracks:
                for track2 in midi2.tracks:
                    outputmidi.tracks.append(track1 + track2)

            self.save_file(f"{args[0].split(".")[0]}-append.mid", outputmidi)
        except Exception as e:
            print(e)

    def do_exit(self, line):
        "exits the program"
        return True


if __name__ == "__main__":
     midiTools().cmdloop()
