"use strict";

function UpdateTeamPanel(data) {
  var score = data.game_score;
  var team = data.team_id;

  var playerId = GetPlayerIdFromTeam(team);
  var playerName = Players.GetPlayerName(playerId);

  var teamPanelName = "team_" + team;

  var rootPanel = $.GetContextPanel();
  var scoreboardContainer = rootPanel.FindChildInLayoutFile(
    "ScoreboardContainer"
  );
  var playersContainerPanel =
    scoreboardContainer.FindChildInLayoutFile("PlayersContainer");
  var teamPanel = playersContainerPanel.FindChild(teamPanelName);

  scoreboardContainer.style.visibility = "visible";

  if (teamPanel == null) {
    // Create the team panel
    teamPanel = $.CreatePanel("Panel", playersContainerPanel, teamPanelName);
    teamPanel.AddClass("PlayerRowContainer");

    $.CreatePanel("Label", teamPanel, "Player");
    $.CreatePanel("Label", teamPanel, "Score");

    // If this is the local player, change the row's style
    var localPlayerTeamId = -1;
    var localPlayer = Game.GetLocalPlayerInfo();
    if (localPlayer) {
      localPlayerTeamId = localPlayer.player_team_id;
    }
    // teamPanel.SetHasClass("local_player_team", localPlayerTeamId == teamId);
    // teamPanel.SetHasClass("not_local_player_team", localPlayerTeamId != teamId);
  }

  var scoreLabel = teamPanel.FindChild("Score");
  var playerNameLabel = teamPanel.FindChild("Player");

  var teamColor = GameUI.CustomUIConfig().team_colors[team];
  teamColor = teamColor.replace(";", "");

  if (playerName != null) {
    playerNameLabel.text = playerName;
    playerNameLabel.style.color = teamColor + ";";
  }
  scoreLabel.text = score;
  scoreLabel.style.color = teamColor + ";";

  // Reorder Scoreboard
  // RoundScoreboard_UpdateAllTeamsAndPlayers( )

  return teamPanel;
}

function RemoveTeamPanels() {
  var rootPanel = $.GetContextPanel();
  var scoreboardContainer = rootPanel.FindChildInLayoutFile(
    "ScoreboardContainer"
  );
  var playersContainerPanel =
    scoreboardContainer.FindChildInLayoutFile("PlayersContainer");
  // Delete all the team panels
  for (var teamId of Game.GetAllTeamIDs()) {
    var teamPanelName = "team_" + teamId;
    var teamPanel = playersContainerPanel.FindChild(teamPanelName);
    if (teamPanel != null) {
      teamPanel.RemoveAndDeleteChildren();
      teamPanel.DeleteAsync(0);
    }
  }
  scoreboardContainer.style.visibility = "collapse";
}

function ResetTeamPanels() {
  GameUI.CustomUIConfig().highscorePrevPlace = [];
  // Set all the panels to default values
  for (var teamId of Game.GetAllTeamIDs()) {
    var data = [];
    data.score = 0;
    data.team_id = teamId;
    if (Game.GetPlayerIDsOnTeam(teamId).length > 0) {
      var teamPanel = UpdateTeamPanel(data);
    }
  }
}

function GetPlayerIdFromTeam(teamId) {
  var playerId;
  if (Game.GetPlayerIDsOnTeam(teamId).length == 1) {
    playerId = Game.GetPlayerIDsOnTeam(teamId)[0];
  }
  return playerId;
}

function OnRoundStart() {
  // ResetTeamPanels();
  RemoveTeamPanels();
}

//=============================================================================
//=============================================================================

function GetTeamPanel(teamDetails) {
  // if we keep this, use it in UpdateTeamPanel
  var team = teamDetails.team_id;

  var teamPanelName = "team_" + team;

  var rootPanel = $.GetContextPanel();
  var scoreboardContainer = rootPanel.FindChildInLayoutFile(
    "ScoreboardContainer"
  );
  var playersContainerPanel =
    scoreboardContainer.FindChildInLayoutFile("PlayersContainer");
  var teamPanel = playersContainerPanel.FindChild(teamPanelName);

  return teamPanel;
}

function RoundScoreboard_UpdateAllTeamsAndPlayers() {
  var teamsList = [];
  for (var teamId of Game.GetAllTeamIDs()) {
    if (Game.GetTeamDetails(teamId).round_score) {
      teamsList.push(Game.GetTeamDetails(teamId));
    }
  }

  // update/create team panels
  var teamsInfo = { max_team_players: 0 };
  var panelsByTeam = [];
  for (var i = 0; i < teamsList.length; ++i) {
    var teamPanel = GetTeamPanel(teamsList[i]);
    if (teamPanel) {
      panelsByTeam[teamsList[i].team_id] = teamPanel;
    }
  }

  $.Msg(teamsList.length);
  if (teamsList.length > 1) {
    // sort
    teamsList.sort(stableCompareFunc);

    // reorder the panels based on the sort
    var prevPanel = panelsByTeam[teamsList[0].team_id];
    for (var i = 0; i < teamsList.length; ++i) {
      var teamId = teamsList[i].team_id;
      var teamPanel = panelsByTeam[teamId];
      ReorderTeam(teamPanel, teamId, i, prevPanel);
      prevPanel = teamPanel;
    }
    //      $.Msg( GameUI.CustomUIConfig().highscorePrevPlace );
  }
}

function ReorderTeam(teamPanel, teamId, newPlace, prevPanel) {
  //  $.Msg( "UPDATE: ", GameUI.CustomUIConfig().highscorePrevPlace );
  var oldPlace = null;
  if (GameUI.CustomUIConfig().highscorePrevPlace.length > teamId) {
    oldPlace = GameUI.CustomUIConfig().highscorePrevPlace[teamId];
  }
  GameUI.CustomUIConfig().highscorePrevPlace[teamId] = newPlace;

  var rootPanel = $.GetContextPanel();
  var scoreboardContainer = rootPanel.FindChildInLayoutFile(
    "ScoreboardContainer"
  );
  var playersContainerPanel =
    scoreboardContainer.FindChildInLayoutFile("PlayersContainer");
  playersContainerPanel.MoveChildAfter(teamPanel, prevPanel);
}

// sort / reorder as necessary
function compareFunc(a, b) {
  // GameUI.CustomUIConfig().sort_teams_compare_func;
  if (a.round_score < b.round_score) {
    return 1; // [ B, A ]
  } else if (a.round_score > b.round_score) {
    return -1; // [ A, B ]
  } else {
    return 0;
  }
}

function stableCompareFunc(a, b) {
  var unstableCompare = compareFunc(a, b);
  if (unstableCompare != 0) {
    return unstableCompare;
  }

  if (GameUI.CustomUIConfig().highscorePrevPlace.length <= a.team_id) {
    return 0;
  }

  if (GameUI.CustomUIConfig().highscorePrevPlace.length <= b.team_id) {
    return 0;
  }

  //          $.Msg( GameUI.CustomUIConfig().highscorePrevPlace );

  var a_prev = GameUI.CustomUIConfig().highscorePrevPlace[a.team_id];
  var b_prev = GameUI.CustomUIConfig().highscorePrevPlace[b.team_id];
  if (a_prev < b_prev) {
    // [ A, B ]
    return -1; // [ A, B ]
  } else if (a_prev > b_prev) {
    // [ B, A ]
    return 1; // [ B, A ]
  } else {
    return 0;
  }
}

//=============================================================================
//=============================================================================

(function () {
  // GameEvents.Subscribe( "score_change", UpdateTeamPanel );
  GameEvents.Subscribe("high_score_change", UpdateTeamPanel);
  GameEvents.Subscribe("round_started", OnRoundStart);
  // GameEvents.Subscribe( "game_end", ClearTeamPanels );
})();
