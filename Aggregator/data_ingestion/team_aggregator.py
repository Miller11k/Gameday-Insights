from sqlalchemy import func
from .schema import GameLog, TeamGameLog

def aggregate_team_game_logs(session):
    print("Aggregating team game logs...")
    agg_query = session.query(
        GameLog.recent_team.label("team_abbr"),
        GameLog.season,
        GameLog.week,
        GameLog.season_type,
        GameLog.opponent_team,
        func.sum(GameLog.completions).label("completions"),
        func.sum(GameLog.attempts).label("attempts"),
        func.sum(GameLog.passing_yards).label("passing_yards"),
        func.sum(GameLog.passing_tds).label("passing_tds"),
        func.sum(GameLog.interceptions).label("interceptions"),
        func.sum(GameLog.sacks).label("sacks"),
        func.sum(GameLog.sack_yards).label("sack_yards"),
        func.sum(GameLog.passing_first_downs).label("passing_first_downs"),
        func.sum(GameLog.carries).label("carries"),
        func.sum(GameLog.rushing_yards).label("rushing_yards"),
        func.sum(GameLog.rushing_tds).label("rushing_tds"),
        func.sum(GameLog.rushing_first_downs).label("rushing_first_downs"),
        func.sum(GameLog.rushing_epa).label("rushing_epa"),
        func.sum(GameLog.special_teams_tds).label("special_teams_tds")
    ).group_by(
        GameLog.recent_team,
        GameLog.season,
        GameLog.week,
        GameLog.season_type,
        GameLog.opponent_team
    )
    
    aggregated_records = []
    for row in agg_query:
        record = {
            "team_abbr": row.team_abbr,
            "season": row.season,
            "week": row.week,
            "season_type": row.season_type,
            "opponent_team": row.opponent_team,
            "completions": int(row.completions or 0),
            "attempts": int(row.attempts or 0),
            "passing_yards": float(row.passing_yards or 0),
            "passing_tds": int(row.passing_tds or 0),
            "interceptions": int(row.interceptions or 0),
            "sacks": float(row.sacks or 0),
            "sack_yards": float(row.sack_yards or 0),
            "passing_first_downs": int(row.passing_first_downs or 0),
            "carries": int(row.carries or 0),
            "rushing_yards": float(row.rushing_yards or 0),
            "rushing_tds": int(row.rushing_tds or 0),
            "rushing_first_downs": int(row.rushing_first_downs or 0),
            "rushing_epa": float(row.rushing_epa or 0),
            "special_teams_tds": int(row.special_teams_tds or 0)
        }
        aggregated_records.append(record)
    
    print(f"Aggregated {len(aggregated_records)} team game log records.")
    if aggregated_records:
        session.bulk_insert_mappings(TeamGameLog, aggregated_records)
        session.commit()
        print("Team game logs aggregated successfully!")
    else:
        print("No team game logs to aggregate.")