"use strict";

function UpdateTeamPanel(data)
{
    var score = data.game_score;
    var team = data.team_id;
    
    var playerId = GetPlayerIdFromTeam(team);
    var playerName = Players.GetPlayerName( playerId );

    var teamPanelName = "team_" + team;

    var rootPanel = $.GetContextPanel();
    var scoreboardContainer = rootPanel.FindChildInLayoutFile("ScoreboardContainer");
    var playersContainerPanel = scoreboardContainer.FindChildInLayoutFile("PlayersContainer");
    var teamPanel = playersContainerPanel.FindChild(teamPanelName);

    scoreboardContainer.style.visibility = "visible";

    if (teamPanel == null)
    {
        // Create the team panel
        teamPanel = $.CreatePanel( "Panel", playersContainerPanel, teamPanelName );
        teamPanel.AddClass("PlayerRowContainer");

        $.CreatePanel("Label", teamPanel, "Player");
        $.CreatePanel("Label", teamPanel, "Score");

        // If this is the local player, change the row's style
        var localPlayerTeamId = -1;
        var localPlayer = Game.GetLocalPlayerInfo();
        if ( localPlayer )
        {
            localPlayerTeamId = localPlayer.player_team_id;
        }
        // teamPanel.SetHasClass("local_player_team", localPlayerTeamId == teamId);
        // teamPanel.SetHasClass("not_local_player_team", localPlayerTeamId != teamId);

        // Change the color depending on the team
        
    }

    var scoreLabel = teamPanel.FindChild("Score");
    var playerNameLabel = teamPanel.FindChild("Player");

    var teamColor = GameUI.CustomUIConfig().team_colors[ team ];
    teamColor = teamColor.replace( ";", "" );
    

    if (playerName != null)
    {
        playerNameLabel.text = playerName;
        playerNameLabel.style.color = teamColor + ";";
    }    
    scoreLabel.text = score;
    scoreLabel.style.color = teamColor + ";";

    // Reorder Scoreboard

    return teamPanel;
}

function RemoveTeamPanels()
{
    var rootPanel = $.GetContextPanel();
    var scoreboardContainer = rootPanel.FindChildInLayoutFile("ScoreboardContainer");
    var playersContainerPanel = scoreboardContainer.FindChildInLayoutFile("PlayersContainer");
    // Delete all the team panels
    for ( var teamId of Game.GetAllTeamIDs() )
    {
        var teamPanelName = "team_" + teamId;
        var teamPanel = playersContainerPanel.FindChild(teamPanelName);
        if (teamPanel != null)
        {
            teamPanel.RemoveAndDeleteChildren();
            teamPanel.DeleteAsync(0);
        }
    }
    scoreboardContainer.style.visibility = "collapse";
}

function ResetTeamPanels()
{
    // Set all the panels to default values
    for ( var teamId of Game.GetAllTeamIDs() )
    {
        var data = [];
        data.team_score = 0;
        data.time = false;
        data.team_id = teamId;
        var teamPanel = UpdateTeamPanel(data);
    }
}

function GetPlayerIdFromTeam(teamId)
{
    var playerId;
    if (Game.GetPlayerIDsOnTeam( teamId ).length == 1){
        playerId = Game.GetPlayerIDsOnTeam( teamId )[0];
    }
    return playerId;
}

function ReorderTeam( scoreboardConfig, teamsParent, teamPanel, teamId, newPlace, prevPanel )
{
//  $.Msg( "UPDATE: ", GameUI.CustomUIConfig().teamsPrevPlace );
    var oldPlace = null;
    if ( GameUI.CustomUIConfig().teamsPrevPlace.length > teamId )
    {
        oldPlace = GameUI.CustomUIConfig().teamsPrevPlace[ teamId ];
    }
    GameUI.CustomUIConfig().teamsPrevPlace[ teamId ] = newPlace;

    teamsParent.MoveChildAfter( teamPanel, prevPanel );
}

// sort / reorder as necessary
function compareFunc( a, b ) // GameUI.CustomUIConfig().sort_teams_compare_func;
{
    if ( a.team_score < b.team_score )
    {
        return 1; // [ B, A ]
    }
    else if ( a.team_score > b.team_score )
    {
        return -1; // [ A, B ]
    }
    else
    {
        return 0;
    }
};

function stableCompareFunc( a, b )
{
    var unstableCompare = compareFunc( a, b );
    if ( unstableCompare != 0 )
    {
        return unstableCompare;
    }
    
    if ( GameUI.CustomUIConfig().teamsPrevPlace.length <= a.team_id )
    {
        return 0;
    }
    
    if ( GameUI.CustomUIConfig().teamsPrevPlace.length <= b.team_id )
    {
        return 0;
    }
    
//          $.Msg( GameUI.CustomUIConfig().teamsPrevPlace );

    var a_prev = GameUI.CustomUIConfig().teamsPrevPlace[ a.team_id ];
    var b_prev = GameUI.CustomUIConfig().teamsPrevPlace[ b.team_id ];
    if ( a_prev < b_prev ) // [ A, B ]
    {
        return -1; // [ A, B ]
    }
    else if ( a_prev > b_prev ) // [ B, A ]
    {
        return 1; // [ B, A ]
    }
    else
    {
        return 0;
    }
};

//=============================================================================
//=============================================================================
function InitializeScoreboard( scoreboardConfig, scoreboardPanel )
{
    GameUI.CustomUIConfig().teamsPrevPlace = [];
    if ( typeof(scoreboardConfig.shouldSort) === 'undefined')
    {
        // default to true
        scoreboardConfig.shouldSort = true;
    }
    _ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardConfig, scoreboardPanel );
    return { "scoreboardConfig": scoreboardConfig, "scoreboardPanel":scoreboardPanel }
}


//=============================================================================
//=============================================================================

(function()
{
    // GameEvents.Subscribe( "score_change", UpdateTeamPanel );
    GameEvents.Subscribe( "high_score_change", UpdateTeamPanel );
    GameEvents.Subscribe( "round_started", RemoveTeamPanels );
    // GameEvents.Subscribe( "game_end", ClearTeamPanels );
})();
