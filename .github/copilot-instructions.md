# foodplanner — code review instructions

Guidance for GitHub Copilot when reviewing pull requests in this repo. Mirrors the GIRAF
coding standards (source of truth: `coding-standards.md` in the girafMCP-py repo).

## Author context
PRs are usually written by **junior university students**, new each semester. Make each review
a teaching moment: explain *why* a point matters and cite the rule. Be direct and specific; no
flattery.

## Don't comment on these (CI and static tools own them)
- `flutter test` failures; formatting / `dart format`; analyzer & lint nits; unused imports;
  naming-only nits; type errors — these belong to `flutter analyze` / `dart format`.
- Generated or vendored code: `foodplanner/lib/api/openapi/**`, `*.g.dart`, `*.freezed.dart`,
  `foodplanner/flutter/**`.

## Focus on what static tools can't see, in priority order

### 1. Security (highest weight)
- Secrets / API keys / tokens committed in code, logs, or config.
- Trusting a client-supplied role instead of the validated JWT. GIRAF auth: giraf-core issues
  JWTs with `org_roles`; authorisation must come from the validated token, never client input.
  Hierarchy: owner > admin > member.
- Missing ownership/authorisation checks; IDOR.
- PII exposure: child/citizen data in logs or error messages. This app serves vulnerable children.

### 2. Correctness / logic bugs
Null handling at boundaries, off-by-one, swallowed errors (empty `catch`), races, missing
`await`, state that won't rebuild.

### 3. Flutter & architecture (GIRAF standards)
- Single Responsibility (always applies): widgets do UI only; business logic, API calls, or
  data transformation inside a widget is a violation — state belongs in a BLoC/Cubit, data
  access in a repository/service.
- Widget hygiene: missing `dispose()` for controllers/subscriptions/focus nodes; missing
  `if (!mounted) return;` after `await` before `setState()`; `Scaffold` nested in `Scaffold`;
  `ListView`/`GridView` in `Column`/`Row` without `Expanded`/`SizedBox`; private `_buildX()`
  helpers that should be separate `StatelessWidget` classes.
- Deprecated APIs: `RaisedButton`/`FlatButton`, `WillPopScope`, `MaterialStateProperty` → use
  `ElevatedButton`/`TextButton`, `PopScope`, `WidgetStateProperty`.
- Unsafe `!` null-assertion where null is not provably impossible.
- Hardcoded colours/text styles instead of `Theme.of(context)`.
- `BuildContext` stored in a field or passed into a service/repository.
- GIRAF shared concepts (users, orgs, citizens, grades, pictograms, auth) belong in giraf-core,
  not re-implemented in this app.

### 4. Scope discipline
Flag drive-by changes unrelated to the PR's stated purpose; ask to split them out.

## Calibrate — don't over-engineer
Only Single Responsibility always applies. Don't ask juniors for new interfaces, use-case
classes, or mappers unless there are 2+ implementations or a test genuinely needs to mock.
Three similar lines beat a premature abstraction.

## Severity
CRITICAL = security breach / data loss / production failure (must fix before merge). HIGH =
likely bug or significant problem (should fix). MEDIUM = standards deviation / tech debt. LOW =
minor or stylistic (skip these). Leave merge and approval decisions to a human supervisor.
