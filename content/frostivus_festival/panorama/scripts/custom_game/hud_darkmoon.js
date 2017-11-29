"use strict";

function OnRoundStarted( roundStartData )
{
	var round_screen_duration = 5.0;
	if ( roundStartData !== null )
	{
		$( "#RoundStartPanel" ).FindChildInLayoutFile( "RoundNameLabel" ).text = roundStartData.round_name;
		$( "#RoundStartPanel" ).SetHasClass( "Round" + ( roundStartData.round_number - 1), false );  
		$( "#RoundStartPanel" ).SetHasClass( "Round" + roundStartData.round_number, true );
		round_screen_duration = roundStartData.round_screen_duration;

		$( "#HoldoutState" ).FindChildInLayoutFile( "RoundNumberContainer" ).FindChildInLayoutFile( "RoundNumber" ).text = roundStartData.round_number;

		var RoundDescriptionPanel = $( "#RoundDescriptionPanel" )
		var roundNameLeftLabel = RoundDescriptionPanel.FindChild( "RoundNameLeftLabel" )
		var descriptionPanel = RoundDescriptionPanel.FindChild( "Description" )
		var roundDescriptionLabel = descriptionPanel.FindChild( "RoundDescriptionLabel" )

		roundNameLeftLabel.text = roundStartData.round_name;
		roundDescriptionLabel.text = roundStartData.round_description;
	}

	$( "#RoundStartPanel" ).SetHasClass( "Visible", true );
	Game.EmitSound( "RoundStart" );
	$.Schedule( 5.0, HideRoundStartPanel );
	$.DispatchEvent( "DOTAHUDHideScoreboard" )

	$( "#RoundDescriptionPanel" ).SetHasClass( "Visible", true );
}

function HideRoundStartPanel()
{
	$( "#RoundStartPanel" ).SetHasClass( "Visible", false );
}

function OnRoundEnd()
{
	// Hide the previous round description, and show the winner
	HideRoundDescription()
}

function HideRoundDescription()
{
	$( "#RoundDescriptionPanel" ).SetHasClass( "Visible", false );
}

GameEvents.Subscribe( "round_started", OnRoundStarted );
GameEvents.Subscribe( "round_end", OnRoundEnd );