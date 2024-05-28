extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelEndFade.color.a = 1
	var tween = self.create_tween()
	tween.tween_property($LevelEndFade, "color:a", 0, 0.5)
	$Control/SongNameLabel.set_text(ScoreSingleton.songName)
	$Control/TotalScoreLabel.set_text("Total Score: " + str(ScoreSingleton.score))
	$Control/TotalPercentageLabel.set_text("Percentage: " + "%4.2f" % ScoreSingleton.percentage + "%")
	$Control/TotalJudgementLabel.set_text("Perfect: " + str(ScoreSingleton.perfects) + "\n" +
		"Good: " + str(ScoreSingleton.goods) + "\n" +
		"Early: " + str(ScoreSingleton.earlys) + "\n" +
		"Late: " + str(ScoreSingleton.lates) + "\n" +
		"Miss: " + str(ScoreSingleton.misses))
	$Control/FinalRankLabel.set_text(ScoreSingleton.rank)
	if ScoreSingleton.misses == 0:
		$Control/FullComboLabel.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
