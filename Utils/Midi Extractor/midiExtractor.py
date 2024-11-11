import pretty_midi

import pretty_midi

def get_midi_info(midi_file_path):
    # Carrega o arquivo MIDI
    midi_data = pretty_midi.PrettyMIDI(midi_file_path)

    # Inicializa a lista de informações do MIDI
    midi_info = []

    bpm = 135

    # Adiciona as informações de BPM à lista de informações do MIDI
    midi_info.append({"bpm": bpm})

    # Adiciona um gráfico vazio à lista de informações do MIDI
    midi_info.append({"chart": []})

    for instrument in midi_data.instruments:
        # Itera sobre cada nota no instrumento e a mapeia para uma pista de jogo
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
            # Adiciona as informações da nota ao mapa de notas
            midi_info[1]["chart"].append({"lane": mappedPitch, "note": note.start, "type": 0})
            if note.end > note.start + 0.3: # Se a nota durar mais de 0.3 segundos
                count = 1
                # Adiciona notas adicionais a cada 1/8 de batida
                while (note.start + ((((60 / bpm) / 8)) * count))  < note.end: 
                    midi_info[1]["chart"].append({"lane": mappedPitch, 
                            "note": note.start + ((60 / bpm) / 8) * count, "type": 1
                        })
                    count += 1
        

    # Retorna a lista de informações do MIDI
    return midi_info

# Caminho do arquivo MIDI a ser processado
midi_file_path = "browhatshort.mid"

# Obtém os tempos de início das notas chamando a função get_note_start_times
midi_info = get_midi_info(midi_file_path)
 
# Salva as informações do MIDI em um arquivo JSON
import json
with open("chart.json", "w") as f:
    json.dump(midi_info, f)