# Cadence Conventions

## Authorization

- Use Pundit policies for actions and policy scopes for record access.
  `ApplicationController` verifies authorization on every action and policy
  scoping on `index`. Public actions need narrow, explicit verification skips.
- Resolve identity on the server through `current_user`. An email address or role
  supplied in a request is input, not an authenticated identity.
- Keep client records scoped to their owner and practitioner notes out of
  client-visible responses. Permit attributes according to the actor's authority.
- See `docs/tooling.md` for the job dashboard's authorization contract.

## Scheduling and time

- Keep service duration, cleanup time, working hours, and booking eligibility
  distinct. Implement the agreed rules in `docs/`; unresolved proposals remain
  decisions to settle.
- Treat displayed availability as advisory. Recheck conflicts atomically when
  saving a booking or reschedule; failed rescheduling must retain the original.
- Compare appointment instants in UTC and interpret working hours and business
  dates in the configured business timezone.
- Preserve exact overlap and cancellation boundaries, including cleanup,
  day boundaries, and daylight-saving transitions.

## Jobs and interface

- Inherit jobs from `ApplicationJob`, which enables enqueue after commit and
  suppresses argument logging. Use the configured Solid Queue workers.
- Before sending a reminder, recheck that its appointment and scheduled time
  still apply.
- Use server-rendered Rails views with Turbo and Stimulus for interaction,
  Importmap for browser dependencies, and Tailwind/DaisyUI for styling.
- Reuse the generic interface helpers documented in `docs/tooling.md` where
  their behavior fits.
