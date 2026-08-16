# Apple Watch Backend Requirements

Base URL: `https://willizo.com/api`

Last updated: `2026-08-16`

This document is the backend delivery contract for the implemented Apple Watch screens. The watch UI, local timer, offline storage, and navigation are already implemented. Items marked **BLOCKER** require backend work before the flow can be considered production-ready.

## Client Data Policy

As of `2026-08-16`, the watch client no longer fabricates business data when an API field is missing:

- No sample exercise, weight, repetitions, rest duration, previous set, meal, achievement, calorie total, workout duration, or completion percentage is created locally.
- Recipes are not reused as today's assigned meals.
- Featured workout plans are not reused as today's scheduled workout.
- A workout is not considered started unless `POST /watch/workouts` returns both a valid session `id` and `started_at`.
- A completion report is not synthesized from plan estimates. Statistics appear only when returned by the completion API.
- Missing optional values render as `--`; missing required records render an empty/unavailable state.

This makes missing backend data visible instead of showing plausible but incorrect values. The fields documented below are therefore required for their corresponding UI sections.

### Values currently shown as unavailable until backend delivery

| Watch area | Fields that must come from backend |
|---|---|
| Home session tile | `summary.sessions_count`, `summary.sessions_duration_minutes` |
| Home meal tile | `summary.meals_count`, `summary.meals_calories`, `summary.consumed_calories`, `summary.daily_calorie_goal` |
| Today's workout card | A real `today_workout` assignment with `schedule_id`, plan identity, category, duration, calories, and scheduled time |
| Today's meals | Scheduled meal IDs, times, completion state, recipe identity/name, and calories from `GET /watch/meals/today` |
| Start / restore | Session UUID, selected plan identity, `status`, and authoritative `started_at` |
| Current exercise | Exercise ID/name, sets, reps, weight, rest seconds, muscle/category, order, and previous set history |
| Completion confirmation | Duration/volume returned or confirmed for the exact session being completed |
| Statistics | Goal progress, calories, calorie goal, heart rate, distance, power, zones, recovery, and achievements |

The live countdown, pause duration, completed-set taps, offline queue status, and current clock are device state rather than mock backend data. They are calculated locally and synchronized when the corresponding write endpoints are available.

All user-specific endpoints require:

```http
Authorization: Bearer <access_token>
Accept: application/json
Content-Type: application/json
```

All workout log/session IDs must use one consistent type. The current API returns UUID strings, so every watch endpoint and client should treat `id` as a string UUID.

## Backend Delivery Checklist

| Priority | Screen / flow | Endpoint | Current state | Backend action |
|---|---|---|---|---|
| P0 | Start Workout | `POST /watch/workouts` | Creates exercise history, not a workout session | **BLOCKER:** create a plan-linked user session and return its UUID |
| P0 | Restore running workout | `GET /watch/workouts/active` | Missing | **BLOCKER:** return the same active/paused session after relaunch |
| P0 | Finish and statistics | `POST /watch/workouts/{session_id}/complete` | Contract exists but does not provide the full statistics payload | **BLOCKER:** complete the exact session and return the summary contract in section 8 |
| P0 | Today's meals | `GET /watch/meals/today` | Returns no assigned meals for the tested user | Return the user's scheduled meal plan and daily totals |
| P1 | Complete set | `POST /watch/workouts/{session_id}/sets` | Missing | Persist sets, current indices, volume, and progress |
| P1 | Pause / resume | `POST .../pause`, `POST .../resume` | Missing | Persist timer state and accumulated pause duration |
| P1 | Home | `GET /watch/home` | Some totals are inferred/fallback values | Return user-specific workout and meal summaries |
| P1 | Meal completion | `POST /watch/meals/{scheduled_meal_id}/complete` | Defined, needs scheduled meal data | Return updated meal and daily calories |
| P2 | Content quality | Workout plans and recipes | Seed data contains mismatched records | Correct Yoga exercises and recipe content |
| P2 | Authentication errors | All authenticated endpoints | Error output can expose framework details | Return stable error codes without stack traces |

## ID and Time Rules

- `workout_session.id`, `schedule_id`, `scheduled_meal.id`, and completed-set IDs must be UUID strings.
- Numeric plan and recipe IDs may remain integers.
- Do not use `exercise_id` as a workout-session ID.
- All server timestamps must be ISO 8601 UTC, for example `2026-08-16T15:30:00Z`.
- Durations must use an explicit unit in the field name. Use `actual_duration_seconds`; do not use ambiguous `actual_duration`.
- Every write endpoint must accept an `Idempotency-Key` header and return the existing result when the same event is retried.

## Current API Test Findings

- `GET /watch/workout-plans`: HTTP 200 and returns four plans.
- `GET /watch/workout-plans/{slug}`: HTTP 200 for all four plans.
- `POST /watch/workouts`: HTTP 201, but creates an exercise history record only.
- `GET /watch/workouts/today`: HTTP 200 with `workouts: []` immediately after the successful POST.
- `GET /watch/workouts/history`: contains the record created by POST.
- The current POST response has no `workout_plan_id`, `workout_plan_slug`, `status`, or `started_at`.
- Exercise ID `019f14db-8501-70c4-ab54-aab1d760a23a` is reused in several plans, so `exercise_id` cannot identify the selected plan.
- `Morning Yoga Flow` currently contains two `Bench Press` exercises. Seed/content data must be corrected.
- Recipe seed data is inconsistent: `Protein Pancakes` returns chicken/quinoa description and ingredients.

## Rollout Compatibility Note

The current watch build follows the old Postman contract:

```text
POST /watch/workouts
  body: exercise_id, value, workout_date, notes

POST /watch/workouts/{integer_id}/complete
  body: actual_duration (minutes)
```

This old contract cannot identify or restore the selected workout plan reliably. Backend should implement the session contract in this document, then coordinate the watch client update to:

- Send `workout_plan_id`, optional `schedule_id`, `started_at`, `timezone`, and `source` when starting.
- Store and reuse the returned string session UUID.
- Send `actual_duration_seconds` and the completion metrics when finishing.

For a staged deployment, the backend may temporarily accept both `actual_duration` in minutes and `actual_duration_seconds`, but responses must always use the explicit `actual_duration_seconds` field. The old fields should be removed after the updated watch build is released.

## 1. Authentication / App Bootstrap

The watch receives the phone user's access and refresh tokens through WatchConnectivity. Backend endpoints required:

```http
POST /auth/refresh
GET /watch/profile
```

`POST /auth/refresh` must return a fresh access token before the old token expires. Authentication errors must return a short production response without framework stack traces:

```json
{
  "success": false,
  "code": "TOKEN_EXPIRED",
  "message": "Authentication token has expired"
}
```

## 2. Home Screen

The Home screen displays session count/duration, meal count/calories, today's workout, and today's scheduled meals.

Existing endpoints:

```http
GET /watch/home
GET /watch/workouts/today
GET /watch/meals/today
```

Recommended single lightweight response for `GET /watch/home`:

```json
{
  "date": "2026-08-16",
  "summary": {
    "sessions_count": 1,
    "sessions_duration_minutes": 50,
    "meals_count": 3,
    "meals_calories": 1850,
    "daily_calorie_goal": 2100
  },
  "today_workout": {
    "schedule_id": "uuid-or-null",
    "workout_plan_id": 1,
    "name": "Do biceps exercise",
    "slug": "do-biceps-exercise",
    "category": "strength",
    "duration_minutes": 50,
    "calories_burned": 250,
    "scheduled_time": "20:00:00",
    "session": null
  },
  "today_meals": [
    {
      "id": "meal-schedule-uuid",
      "meal_type": "breakfast",
      "scheduled_time": "08:00:00",
      "is_completed": false,
      "recipe": {
        "id": 3,
        "name": "Oatmeal Energy Bowl",
        "slug": "oatmeal-energy-bowl",
        "calories": 380
      }
    }
  ]
}
```

Missing/fix required:

- Return real user-specific counts instead of values derived from all public plans/recipes.
- Return a daily calorie goal from the user's plan, not a hardcoded `2100`.
- Include the active session under `today_workout.session` when one exists.
- Pull-to-refresh reuses this endpoint; no separate refresh endpoint is needed.

## 3. Workout Sessions List

Screen: `START WORKOUT` list containing the four workout cards.

Existing endpoint:

```http
GET /watch/workout-plans
```

Current list fields are sufficient for the card:

```json
{
  "id": 1,
  "name": "Do biceps exercise",
  "slug": "do-biceps-exercise",
  "difficulty": "beginner",
  "duration_minutes": 50,
  "calories_burned": 250,
  "category": "strength",
  "is_featured": true
}
```

Fix required:

- Correct workout-plan seed data and exercise relationships.
- Do not infer whether a plan has started from this endpoint. Start state belongs to a user workout session.

## 4. Workout Landing and Show Info

Screens: workout landing (`START WORKOUT`, `SHOW INFO`) and exercise detail.

Existing endpoint:

```http
GET /watch/workout-plans/{slug}
```

Required plan response:

```json
{
  "workout_plan": {
    "id": 1,
    "name": "Do biceps exercise",
    "slug": "do-biceps-exercise",
    "description": "...",
    "difficulty": "beginner",
    "duration_minutes": 50,
    "calories_burned": 250,
    "category": "strength",
    "equipment_needed": ["dumbbells"],
    "exercises": [
      {
        "id": "exercise-uuid",
        "name": "Bicep Curls",
        "slug": "bicep-curls",
        "category": "arms",
        "unit": "reps",
        "sets": 3,
        "reps": 12,
        "weight": 20,
        "duration_seconds": null,
        "rest_seconds": 60,
        "order": 1
      }
    ]
  }
}
```

Missing/fix required:

- Add `weight` when the plan prescribes weight; otherwise return `null`.
- Correct duplicate/wrong exercises, especially Yoga.
- Plan details must not contain another user's `started_at`. Session state comes from the active-session endpoint.

Previous set data may use the existing endpoint:

```http
GET /watch/workouts/history?exercise_id={exercise_uuid}&limit=1
```

The response should explicitly include `reps` and `weight`:

```json
{
  "data": [
    {
      "exercise_id": "exercise-uuid",
      "reps": 12,
      "weight": 20,
      "completed_at": "2026-08-15T18:20:00Z"
    }
  ]
}
```

## 5. Start Workout and Restore Active Workout

This is the main missing backend contract.

Change the existing endpoint to create a real workout session. A dedicated `POST /watch/workout-sessions` endpoint is also acceptable, but the backend and watch app must use one route consistently:

```http
POST /watch/workouts
```

Required request:

```json
{
  "workout_plan_id": 1,
  "schedule_id": "optional-schedule-uuid",
  "started_at": "2026-08-16T18:30:00+03:00",
  "timezone": "Asia/Riyadh",
  "source": "apple_watch"
}
```

Required headers:

```http
Authorization: Bearer <access_token>
Idempotency-Key: <watch-generated-uuid>
```

Required HTTP 201 response:

```json
{
  "workout": {
    "id": "workout-session-uuid",
    "workout_plan_id": 1,
    "workout_plan_slug": "do-biceps-exercise",
    "status": "active",
    "started_at": "2026-08-16T15:30:00Z",
    "paused_at": null,
    "accumulated_pause_seconds": 0,
    "current_exercise_index": 0,
    "current_set_index": 0,
    "completed_sets": []
  }
}
```

Add an active-session endpoint:

```http
GET /watch/workouts/active
```

It must return the same session after the watch app is closed/reopened. Return HTTP 200 with `workout: null` when no session is active.

The response must also include enough plan data to restore the current screen without making assumptions from a different workout:

```json
{
  "workout": {
    "id": "workout-session-uuid",
    "workout_plan_id": 1,
    "workout_plan_slug": "do-biceps-exercise",
    "workout_plan_name": "Do biceps exercise",
    "status": "active",
    "started_at": "2026-08-16T15:30:00Z",
    "paused_at": null,
    "accumulated_pause_seconds": 0,
    "current_exercise_index": 0,
    "current_set_index": 0,
    "completed_sets": [],
    "plan": {
      "duration_minutes": 50,
      "calories_burned": 250,
      "exercises": []
    }
  }
}
```

`GET /watch/workouts/today` must also include the active session. The current behavior (`POST` returns 201, then `today` returns an empty array) is incorrect.

Start must be idempotent. Sending an `Idempotency-Key` or the same active plan must not create duplicate sessions.

## 6. Current Exercise, Complete Set, Rest Timer, and Progress

The watch can run the timer locally, but completed sets must be persisted so an interrupted workout can resume on another launch/device.

Missing endpoint:

```http
POST /watch/workouts/{workout_session_uuid}/sets
```

Request:

```json
{
  "exercise_id": "exercise-uuid",
  "set_number": 1,
  "reps": 12,
  "weight": 20,
  "completed_at": "2026-08-16T15:35:00Z"
}
```

Response:

```json
{
  "set": {
    "id": "set-uuid",
    "exercise_id": "exercise-uuid",
    "set_number": 1,
    "reps": 12,
    "weight": 20,
    "completed_at": "2026-08-16T15:35:00Z"
  },
  "session": {
    "status": "resting",
    "current_exercise_index": 0,
    "current_set_index": 1,
    "completed_sets_count": 1,
    "total_sets_count": 6,
    "progress": 0.1667
  }
}
```

The rest countdown can remain local. The server only needs the exercise's `rest_seconds` and persisted current indices/progress.

## 7. Pause and Resume

The timer runs locally, but pause state should be persisted for reliable restore.

Missing endpoints:

```http
POST /watch/workouts/{workout_session_uuid}/pause
POST /watch/workouts/{workout_session_uuid}/resume
```

Pause request:

```json
{"paused_at":"2026-08-16T15:40:00Z"}
```

Resume request:

```json
{"resumed_at":"2026-08-16T15:42:00Z"}
```

Both responses must return the updated session with `status`, `paused_at`, and `accumulated_pause_seconds`.

## 8. Finish Workout and Workout Complete Screen

Existing endpoint:

```http
POST /watch/workouts/{workout_session_uuid}/complete
```

Required request:

```json
{
  "finished_at": "2026-08-16T16:20:00Z",
  "actual_duration_seconds": 2880,
  "total_volume": 12450,
  "volume_unit": "kg",
  "calories": 250,
  "average_heart_rate": null,
  "max_heart_rate": null,
  "distance_kilometers": null,
  "average_power": null,
  "source": "apple_watch"
}
```

Health fields may be `null` until HealthKit is implemented.

Required response:

```json
{
  "workout": {
    "id": "workout-session-uuid",
    "status": "completed",
    "workout_plan_id": 1,
    "workout_plan_slug": "do-biceps-exercise",
    "started_at": "2026-08-16T15:30:00Z",
    "finished_at": "2026-08-16T16:20:00Z",
    "actual_duration_seconds": 2880,
    "total_volume": 12450,
    "volume_unit": "kg",
    "completed_sets_count": 6,
    "total_sets_count": 6,
    "progress": 1.0,
    "goal_progress_percent": 100,
    "calories": 250,
    "calorie_goal": 300,
    "average_heart_rate": null,
    "max_heart_rate": null,
    "distance_kilometers": null,
    "average_power": null,
    "recovery_minutes": null,
    "heart_rate_zones": {
      "peak_percent": null,
      "cardio_percent": null,
      "fat_burn_percent": null,
      "warm_up_percent": null
    },
    "achievements": []
  }
}
```

Fix required:

- Accept the UUID returned by Start.
- Return completion summary fields rather than only acknowledging the request. The statistics page reads this response directly.
- Return `total_volume` from completed sets (`weight * reps`) using one documented weight unit.
- Return `progress`, completed/total set counts, and `goal_progress_percent`; do not hardcode a percentage in the client.
- Return `calorie_goal` with `calories` so the progress card can show a real goal.
- Return HealthKit-dependent fields as `null` until HealthKit is added. Never return fake heart-rate, distance, power, zone, or recovery values.
- Return `achievements` only when earned. An empty array is valid.
- Retrying the same completion request must be idempotent.

The implemented finish flow is:

```text
Timer reaches zero
  -> Watch saves the finished session locally
  -> Watch displays the compact Workout Complete screen
  -> User taps FINISH
  -> POST /watch/workouts/{session_id}/complete
  -> Watch displays the statistics page using the response above
```

The compact screen can calculate duration and total volume locally. The server response remains authoritative for the final statistics and future synchronization with iPhone.

## 9. Today's Meals Screen

The screen represents the user's scheduled meals, not every public recipe.

Existing endpoint:

```http
GET /watch/meals/today
```

Required response:

```json
{
  "date": "2026-08-16",
  "daily_calorie_goal": 2100,
  "consumed_calories": 1240,
  "meals": [
    {
      "id": "scheduled-meal-uuid",
      "meal_type": "breakfast",
      "scheduled_time": "08:00:00",
      "is_completed": true,
      "recipe": {
        "id": 3,
        "name": "Oatmeal Energy Bowl",
        "slug": "oatmeal-energy-bowl",
        "image_url": "/images/recipes/shared-meal.png",
        "calories": 380
      }
    }
  ]
}
```

`GET /watch/recipes` may remain available for recipe browsing, but it must not replace the user's `meals/today` schedule.

Current visible failure: the Watch Home meal card can show recipe totals while the `Today's Fuel` list is empty. This happens when the client has public recipe fallback data but `/watch/meals/today` has no user schedule. The backend must return the same scheduled meals and totals consistently from both `/watch/home` and `/watch/meals/today`.

Required consistency rules:

- `summary.meals_count` equals `today_meals.count` unless pagination is explicitly returned.
- `summary.meals_calories` equals the sum of scheduled meal recipe calories.
- `consumed_calories` counts completed meals only.
- `daily_calorie_goal` comes from the authenticated user's active nutrition plan.
- Every meal contains a stable `scheduled_meal_id`; a recipe ID alone cannot complete a scheduled meal.

## 10. Meal Details and Complete Meal

Existing endpoints:

```http
GET /watch/recipes/{slug}
POST /watch/meals/{scheduled_meal_uuid}/complete
```

Recipe detail already returns nutrition and ingredients. Fix inconsistent seed content so name, description, ingredients, and image describe the same recipe.

Complete meal response should be:

```json
{
  "meal": {
    "id": "scheduled-meal-uuid",
    "is_completed": true,
    "completed_at": "2026-08-16T05:10:00Z"
  },
  "daily_totals": {
    "consumed_calories": 1240,
    "daily_calorie_goal": 2100
  }
}
```

## 11. Offline Sync

The watch stores pending set/completion events locally when the phone/network is unavailable. Backend write endpoints must support:

- UUID idempotency keys supplied by the watch.
- Replaying the same set or completion event without duplicates.
- Server timestamps in ISO 8601 UTC.
- A deterministic conflict response containing the latest session.

Recommended header:

```http
Idempotency-Key: <watch-generated-uuid>
```

Recommended conflict response:

```json
{
  "success": false,
  "code": "SESSION_STATE_CONFLICT",
  "message": "Workout session has changed",
  "workout": {
    "id": "workout-session-uuid",
    "status": "active",
    "current_exercise_index": 1,
    "current_set_index": 0,
    "completed_sets": []
  }
}
```

## 12. Required Error Contract

All watch endpoints must return a stable JSON error body:

```json
{
  "success": false,
  "code": "WORKOUT_SESSION_NOT_FOUND",
  "message": "Workout session was not found"
}
```

Required codes:

- `TOKEN_EXPIRED` with HTTP 401.
- `VALIDATION_ERROR` with HTTP 422 and a small `errors` object.
- `WORKOUT_SESSION_NOT_FOUND` with HTTP 404.
- `WORKOUT_ALREADY_COMPLETED` with HTTP 409, or HTTP 200 with the original completion response when the idempotency key matches.
- `SESSION_STATE_CONFLICT` with HTTP 409 and the latest session.

Do not return HTML, Laravel exception pages, SQL errors, JWT traces, or stack traces to the watch.

## 13. Backend Acceptance Tests

The backend task is complete only when these tests pass with one authenticated test user:

1. Start Plan A and receive a session UUID linked to Plan A.
2. `GET /watch/workouts/active` returns Plan A with the same start time after app relaunch.
3. Starting Plan A again with the same idempotency key does not create another session.
4. Completing a set updates completed set count, indices, volume, and progress.
5. Pause and resume preserve elapsed time without counting paused seconds.
6. Completing the session UUID returned by Start succeeds and marks that exact session completed.
7. Repeating Complete with the same idempotency key returns the original completion result without duplication.
8. The completion response contains every field in section 8; unavailable health metrics are JSON `null`.
9. A workout that has never started has `session: null` and no `started_at` borrowed from another plan.
10. `/watch/home` and `/watch/meals/today` return matching scheduled meal totals.
11. Completing a scheduled meal updates `consumed_calories` on both endpoints.
12. Expired authentication returns `TOKEN_EXPIRED` without a stack trace.

## Backend Priority

1. Fix Start to create a real plan-linked workout session and return a UUID.
2. Add `GET /watch/workouts/active` and make `today` return the started session.
3. Make Complete accept the same Start UUID and return the full statistics response from section 8.
4. Return the authenticated user's scheduled meals from Home and Today's Meals.
5. Add set persistence plus pause/resume.
6. Add idempotency and the error contract to all write endpoints.
7. Fix workout and recipe seed relationships/content.
8. Remove Laravel/JWT stack traces from production authentication errors.
