"use strict";

function UpdateRecentScore()
{
//	$.Msg( "UpdateRecentScore" );
	var TIME_TO_SHOW_RECENT_SCORE_DS = 10; // 2s
	var teamPanel = $.GetContextPanel();

	var curTimeDS = Game.GetGameTime() * 10;
	var recentScore = teamPanel.GetAttributeInt( "recent_score_count", 0 );
	var timeOfRecentScoreDS = teamPanel.GetAttributeInt( "ds_time_of_most_recent_score", 0 );

	if ( timeOfRecentScoreDS + TIME_TO_SHOW_RECENT_SCORE_DS < curTimeDS )
	{
		teamPanel.SetAttributeInt( "recent_score_count", 0 );
		teamPanel.SetAttributeInt( "ds_time_of_most_recent_score", 0 );
		recentScore = 0;
	}

	var recentScorePanel = teamPanel.FindChildInLayoutFile( "RecentScore" );

	if ( recentScore === 0 )
	{
		recentScorePanel.SetHasClass( "recent_score", false );
		recentScorePanel.SetHasClass( "no_recent_score", true );
	}
	else
	{
		recentScorePanel.SetDialogVariableInt( "score", recentScore );
		recentScorePanel.text = $.Localize( "#RecentScore", recentScorePanel );
		recentScorePanel.SetHasClass( "recent_score", true );
		recentScorePanel.SetHasClass( "no_recent_score", false );
	}
}

function OnScoreChange(event)
{
	var curTimeDS = Game.GetGameTime() * 10;
	var teamPanel = $.GetContextPanel();
	var teamId = $.GetContextPanel().GetAttributeInt( "team_id", -1 );

	$.Msg( "OnScoreChange:", event, " ? ", teamId );
	if ( teamId !== event.team_id )
		return;

	var recentScore = teamPanel.GetAttributeInt( "recent_score_count", 0 );
	recentScore += event.score;
	teamPanel.SetAttributeInt( "recent_score_count", recentScore );
	teamPanel.SetAttributeInt( "ds_time_of_most_recent_score", curTimeDS );

	// var pointsToWinPanel = teamPanel.FindChildInLayoutFile( "PointsToWin" );
	// pointsToWinPanel.SetDialogVariableInt( "points_to_win", event.kills_remaining );

	UpdateRecentScore();
	$.Schedule( 1, UpdateRecentScore );
}

(function()
{
//	$.Msg( "overthrow_scoreboard_team_overlay" );

	var teamPanel = $.GetContextPanel();
	teamPanel.SetAttributeInt( "recent_score_count", 0 );
	teamPanel.SetAttributeInt( "ds_time_of_most_recent_score", 0 );
	//GameEvents.Subscribe( "kill_event", OnKillEvent );
	//GameEvents.Subscribe( "score_change", OnScoreChange );
})();
