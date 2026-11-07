# Cadence Technical Plan and Developer Questions

Build a small Rails application around a deterministic availability engine, a reliable booking transaction, and one persistent client identity. Validate the scheduling rules against concrete calendars before building the full booking interface: that behavior is the user’s principal reason for replacing the current scheduler.

This is a design proposal for a greenfield repository. No application, database, framework version, or provider integration has been implemented. Scope and user intent are described in the [user story summary](user-story-executive-summary.md), based on [the recording](../cadence-spec-1.wav) and [the follow-up](../cadence-spec-2.txt).

## Proposed implementation

Use one Rails monolith with responsive, server-rendered pages and modest JavaScript for booking interactions. Start with one practitioner calendar. Select and pin Ruby/Rails versions, a relational database, authentication, and deployment tooling with the developer. Use conventional Minitest coverage and RuboCop once configured.

The main records are:

| Area | Minimum information and responsibility |
| --- | --- |
| Practitioner settings and availability | Business timezone, recurring hours, dated exceptions or blocked time, cleanup duration, reminder offsets. |
| Appointment offerings | The five requested durations: 60, 90, 120, 150, and 180 minutes; names and prices to be supplied. |
| Client identity and profile | Unique normalized email, verified access, contact information, completed intake, policy acceptance with version/time, processor references, private practitioner notes. Do not conflate a client profile with an authenticated session. |
| Appointments | Client, offering, start/end, reserved cleanup interval, status, and relevant duration/price snapshots so later edits do not rewrite history. Preserve canceled appointments in history. |
| Payments and notifications | Processor operation references/status and durable message delivery records sufficient to retry safely and diagnose failures. |

Keep practitioner and client access separate. Clients may access only their own records; practitioner notes never appear in client responses. Propose passwordless email verification for clients, persistent sessions, and an automatically created profile rather than a separate signup flow. Use bounded, expiring verification tokens and rate limits. Email lookup alone is not authentication; do not expose profile existence or merge accounts merely because an unverified visitor supplied an address.

## The scheduling decision

Model appointments as occupied time covering service plus 15 minutes of cleanup. Use half-open intervals so the next appointment may start exactly when cleanup ends. The phrase “75 minute gap” is interpreted as space for another 60-minute service plus cleanup, not a mandatory 75-minute idle period; the recording’s 2:15 p.m. example supports that interpretation.

Proposed rule, pending confirmation:

1. Find free intervals within the practitioner’s working hours after subtracting appointments, cleanup, and blocked time. Use local business dates for hours and UTC instants for comparisons.
2. Enumerate starts for the requested duration on a proposed 15-minute grid. Reject those whose occupied interval does not fit. Check both sides of each placement, including opening, closing, and breaks.
3. Assess how much of each remaining interval can be filled using the offered durations plus cleanup: 75, 105, 135, 165, or 195 minutes. A small bounded calculation can find the minimum unusable remainder. A rule that merely rejects gaps shorter than 75 minutes is insufficient: 90 minutes can still leave 15 minutes unusable.
4. Within each existing free interval, offer all starts that minimize total unusable remainder. This preserves choices across separate openings and permits a booking when a perfect fit is impossible. If a remainder is unavoidable, prefer fewer fragments, then retain tied choices. The treatment of leftover time at day boundaries still needs agreement.

This is a proposed interpretation, not an agreed algorithm. It optimizes usable time rather than forecasting demand or guaranteeing the maximum number of future clients. Confirm whether the user instead intends a fixed sequence based on the requested appointment length, or prioritizes the number of clients over unused minutes.

The initial examples to settle are noon–2:00 p.m. plus cleanup, followed by one-hour options at 2:15, 3:30, and 4:45, with 2:45 rejected. Under the proposed rule, 4:00 may also work because a 90-minute service plus cleanup fits beforehand. Validate all five durations, the first booking on an empty day, openings between bookings, and the two-hour opening with an unavoidable remainder. Never move an existing booking automatically to improve packing.

## Booking and integration reliability

Finalize a booking only after identity, required intake, policy acceptance, and the required card setup have succeeded. Recheck availability and save atomically. For the proposed single-practitioner scope, a database transaction locking the practitioner’s scheduling record is a simple way to serialize conflicting booking and availability changes. Every write path, including practitioner edits, must obey the same rule. A repeated submission must return the existing result rather than create another appointment.

For rescheduling, secure the new slot and update the appointment in one transaction; a failure retains the original booking. Enforce the cancellation cutoff on the server using the currently scheduled start before applying the change, not the requested replacement start. Schedule edits affecting existing bookings require an explicit resolution. Keep a minimal record of appointment changes for support.

Propose Stripe as the initial processor. Its Setup Intents flow supports saving a payment method without an immediate charge; use provider-hosted card fields and retain processor identifiers rather than raw card data. Record consent for the intended future use. Saving a card does not itself mean payment has been taken. Charging time, amounts, and refund handling depend on the business decisions below. See [Stripe’s saved payment method documentation](https://docs.stripe.com/payments/save-and-reuse.md?payment-ui=elements).

If payment is required to confirm a booking, add an explicit pending reservation with expiry and a recovery path for payment success after expiry; a database lock must not remain open during an external payment call. Otherwise, do not add temporary slot holds by default. Verify processor webhook signatures, deduplicate events, and reconcile retries without double charging or duplicating appointments. See [Stripe’s webhook guidance](https://docs.stripe.com/webhooks).

Use durable background jobs for confirmations and email/SMS reminders; Active Job with Solid Queue is a conventional option. Configure offsets beyond 24 hours, including 72, 96, and 120 hours, and permit both channels. Persist notification intent with the booking, retry failures, and recheck appointment state/version before delivery so changed or canceled bookings do not produce stale reminders. Skip reminder times already past when a late booking is made; still send confirmation. See [Rails Active Job documentation](https://guides.rubyonrails.org/active_job_basics.html).

Choose one email provider and one SMS provider. Collect SMS permission and honor opt-outs. Show booking success independently of message delivery, with delivery failures visible to the practitioner. Before launch, configure HTTPS, secret storage, backups, and job/error monitoring. Confirm what the intake and notes contain before choosing data retention and hosting requirements.

## Decisions needed from the developer

| Decision | Question and proposed starting point |
| --- | --- |
| Initial business scope | Is this one practitioner, one location, and one calendar? Assume yes; confirm the business timezone. |
| Gap-selection rule | Should any of the five service lengths make a gap usable, allowing 4:00 in the example, or must options follow the stated 75-minute sequence? Prefer all lengths. Is minimizing unusable minutes the right objective, or maximizing client count? |
| Boundaries and unavoidable gaps | Must the final cleanup finish before closing? Apply the rule before the first booking and around breaks? Propose yes to both, with least-waste placements when some remainder is unavoidable. Is a 15-minute start grid acceptable? |
| Booking limits and practitioner control | How soon and how far ahead may clients book? May the practitioner deliberately create a gap the public scheduler would avoid? Propose allowing explicit gap exceptions while still preventing overlap. |
| Cancellation and rescheduling | Is exactly 48 hours allowed, measured as elapsed time rather than calendar days? Propose yes, against the current start before the change. Must a replacement appointment also be at least 48 hours away? What happens inside the cutoff, including practitioner exceptions? Do not infer automatic fees. |
| Payment workflow | Is a saved card mandatory? When are services charged, at what prices/currency, and by whom? Are deposits, no-show fees, late-cancellation fees, or refunds required? Choose one processor initially; confirm Stripe. |
| Client continuity and intake | Is email-link/code access acceptable? What fields and policy text are required, and must intake be completed before confirmation? Propose one fixed form, completed once, with later corrections possible. Are existing client/appointment records to be imported? No migration is assumed. |
| Communications | Which channel sends booking confirmations, and what reminder offsets should be the initial defaults? Propose email confirmation plus separately configurable email/SMS reminders; confirm provider accounts and a contact route for late changes. |
| Technical baseline and data | What Ruby/Rails versions, database, hosting, and practitioner authentication should be used? What sensitive information goes into forms/notes, and what retention is required? These choices affect implementation and operation. |

## Delivery sequence and verification

1. **Resolve the scheduling examples and launch rules.** Agree on the gap objective, boundaries, payment timing, and the 48-hour policy. Prove the availability calculation with focused examples before UI work.
2. **Build the complete appointment loop.** Implement practitioner availability, email identity, client history, intake and notes, booking, and atomic cancellation/rescheduling. Verify simultaneous booking attempts, failed reschedules, access separation, cleanup, daylight-saving transitions, and the exact cutoff.
3. **Add the required integrations and prepare for launch.** Complete saved-card/payment behavior, confirmation and both reminder channels. Verify duplicate submissions/events, payment failures where applicable, delivery retries, and cancellation/rescheduling after reminders have been queued. Review the short booking flow with the intended user.

These are implementation stages, not separate product scope cuts: saved cards and both reminder channels remain part of the requested first release. Use focused model, service, request, job, and integration tests for the behavior implemented. Run RuboCop after code changes; run system tests only if explicitly requested. No application code or tests are part of this design task.
