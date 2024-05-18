import pretty_midi

def get_note_start_times(midi_file_path):
    midi_data = pretty_midi.PrettyMIDI(midi_file_path)
    note_start_times = []

    for instrument in midi_data.instruments:
        for note in instrument.notes:
            if note.pitch == 48:
                note_start_times.append(0)
            elif note.pitch == 49:
                note_start_times.append(1)
            elif note.pitch == 50:
                note_start_times.append(3)
            elif note.pitch == 51:
                note_start_times.append(2)

    return note_start_times

# Example usage:
midi_file_path = "determination note.mid"
note_start_times = get_note_start_times(midi_file_path)

# save the note start times to a file
with open("note_start_times.txt", "w") as f:
    for note_start_time in note_start_times:
        f.write(str(note_start_time) + ",")