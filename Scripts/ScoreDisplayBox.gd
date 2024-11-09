extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_high_score_label(song_name):
	var scorePath = "./Charts/" + song_name + "/score.txt"
	if FileAccess.file_exists(scorePath):
		var score_file = FileAccess.open(scorePath, FileAccess.READ)
		var json_data = score_file.get_as_text()
		var existing_score_data = {}
		if json_data != "":
			existing_score_data = JSON.parse_string(json_data)

		var total_hits = (
			int(existing_score_data.get("perfects", 0))
			+ int(existing_score_data.get("goods", 0))
			+ int(existing_score_data.get("earlys", 0))
			+ int(existing_score_data.get("lates", 0))
		)

		$HighScoreLabel.text = (
			"High Score: \n    "
			+ str(existing_score_data.get("score", 0))
			+ "\nPercentage: \n    "
			+ "%4.2f" % float(existing_score_data.get("percentage", 0))
			+ "%\n"
			+ "Notes:\n    "
			+ str(total_hits)
			+ "/"
			+ str(total_hits + int(existing_score_data.get("misses", 0)))
			+ "\n"
			+ "Rank: \n    "
			+ existing_score_data.get("rank", "F")
		)
		score_file.close()
	else:
		$HighScoreLabel.text = "High Score: \n    -\nPercentage: \n    -\nNotes:\n    -\nRank: \n    -"
