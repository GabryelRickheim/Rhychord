import pretty_midi

def get_note_start_times(midi_file_path):
    midi_data = pretty_midi.PrettyMIDI(midi_file_path)
    note_start_times = []

    for instrument in midi_data.instruments:
        for note in instrument.notes:
            note_start_times.append(note.start)

    return note_start_times

# Example usage:
midi_file_path = "determination.mid"
note_start_times = get_note_start_times(midi_file_path)

# save the note start times to a file
with open("note_start_times.txt", "w") as f:
    for note_start_time in note_start_times:
        f.write(str(note_start_time) + ",")