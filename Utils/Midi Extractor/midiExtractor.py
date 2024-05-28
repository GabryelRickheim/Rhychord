import pretty_midi
#save pitch and start time of each note in a midi file to a json

def get_midi_info(midi_file_path):
    midi_data = pretty_midi.PrettyMIDI(midi_file_path)
    midi_info = []
    midi_info.append({"bpm": 180})
    midi_info.append({"beatsPerBar": 4})
    midi_info.append({"chart": []})
    for instrument in midi_data.instruments:
        for note in instrument.notes:
            if note.pitch == 48:
                mappedPitch = 0
            elif note.pitch == 49:
                mappedPitch = 1
            elif note.pitch == 50:
                mappedPitch = 3
            elif note.pitch == 51:
                mappedPitch = 2
            else:
                mappedPitch = note.pitch
            midi_info[2]["chart"].append({"lane": mappedPitch, "note": note.start})
    return midi_info

# Caminho do arquivo MIDI a ser processado
midi_file_path = "race.mid"

# Obtém os tempos de início das notas chamando a função get_note_start_times
midi_info = get_midi_info(midi_file_path)
 
# Salva as informações do MIDI em um arquivo JSON
import json
with open("chart.json", "w") as f:
    json.dump(midi_info, f)