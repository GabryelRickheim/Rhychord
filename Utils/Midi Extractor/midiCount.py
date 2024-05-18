import pretty_midi

def count_notes_in_file(midi_file_path):
    midi_data = pretty_midi.PrettyMIDI(midi_file_path)
    total_notes = 0

    for instrument in midi_data.instruments:
        total_notes += len(instrument.notes)

    return total_notes

# Example usage:
midi_file_path = "determination.mid"
total_notes = count_notes_in_file(midi_file_path)
print("Total number of notes in the MIDI file:", total_notes)