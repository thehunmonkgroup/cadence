# Cadence project instructions

- Cadence is a greenfield project with a Rails skeleton. Product behavior is still in the application design phase. Do not assume an existing production system, legacy compatibility requirements, or implemented scheduling features.
- Never stage changes unless explicitly directed to by the developer. Leave changes unstaged so the developer can perform iterative staging review. A request to edit or implement something is not permission to stage it.
- Use the `rails-coding` skill at `.agents/skills/rails-coding/SKILL.md` when considering changes to code or tests, including Rails architecture decisions.
- Keep the system minimal. Distinguish explicit user requirements from necessary supporting behavior, proposed defaults, and unresolved questions. Do not add features unless requested or necessary for the scheduler to operate as intended.
- Treat the source requests as input from the intended nontechnical user. Fill in necessary operational details without assuming that every customary scheduling feature belongs in the product.
- Preserve source request files. Keep design documents in `docs/` and identify their source material and unresolved assumptions.
