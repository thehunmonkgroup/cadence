# Cadence User Story Executive Summary

Cadence should make it easy for clients to book and manage appointments while helping the practitioner preserve usable time in the working day. The defining requirement is to offer a broad choice of appointment times without creating avoidable gaps that cannot accommodate another client. A short booking process, unmistakable confirmation, and continuity between visits are essential.

This initial scope assumes one practitioner with one appointment calendar. That is a proposed starting point, not a confirmed business constraint.

## The practitioner’s story

The combined request, paraphrased in first person:

“I offer appointments lasting one, one and a half, two, two and a half, or three hours. I need 15 minutes after each appointment for cleanup. Clients should have plenty of times to choose from, but the scheduler should protect my day from unusable fragments. It should not force everyone into only the next available appointment, and it should still accept a booking when some leftover time is unavoidable.

“I need to adjust my working schedule and see my appointments. Each client should have one continuing profile, with previous appointments, completed intake forms, a saved card, and notes I can keep for my own reference. I need automated booking confirmation and both email and text reminders, with timing I can set several days ahead of the appointment. Clients should be able to cancel or reschedule themselves until the 48-hour cutoff.”

These are explicit requests, except that keeping practitioner notes private is a necessary interpretation of their intended use.

## The client’s journey

1. **Choose an appointment and time.** The client sees the available durations and actual bookable times, with the appointment length, price once defined, and timezone clear. The scheduler accounts for cleanup and the practitioner’s availability.
2. **Identify themselves once.** An email address creates or reconnects the client’s profile without a separate account-registration exercise. Proposed approach: an email link or code verifies access when needed, and a remembered session keeps repeat booking simple. Entering somebody else’s email must not expose their information or saved card.
3. **Complete only what is missing.** New clients provide the required contact details and intake information, accept the cancellation policy, and save a card through the payment provider. Returning clients reuse those records and only update information or replace a card when needed. A fixed intake form is sufficient initially.
4. **Finish with certainty.** One clear final action produces an explicit “Appointment confirmed” result with date, time, duration, and management instructions, followed by an automated confirmation message. Selecting a time or saving a card alone does not mean an appointment is booked. If the time becomes unavailable, explain that and preserve entered information so the client can choose another.
5. **Return and manage the appointment.** Clients can see their own upcoming and past appointments, book again, and cancel or reschedule before the cutoff. Both email and text reminders support practitioner-selected timing, including three, four, or five days beforehand. A schedule change updates subsequent reminders.

Email verification, preserving entered information, and clear failure handling are proposed supporting behavior needed to make the requested simplicity and continuity reliable.

## What smart availability means

The recording’s example has an existing appointment from noon to 2:00 p.m., followed by cleanup until 2:15 p.m. For a client seeking a one-hour appointment:

| Possible start | Interpretation of the request |
| --- | --- |
| 2:15 p.m. | Offer it when the rest of the schedule permits; it follows cleanup directly. |
| 2:45 p.m. | Normally exclude it: it strands 30 minutes after cleanup. |
| 3:30 p.m. | Offer it when the rest of the schedule permits; the preceding 75 minutes can hold a one-hour appointment and cleanup. |
| 4:45 p.m. | Offer it when the rest of the schedule permits; the preceding 150 minutes can hold two one-hour appointments and their cleanup. |

These are alternatives, not simultaneous reservations. The system must also check the space after the proposed booking, earlier appointments, breaks, and the end of the working day.

One point needs confirmation: the stated goal suggests that 4:00 p.m. could also be offered, because the 105 minutes after 2:15 can hold a 90-minute appointment and cleanup. The spoken sequence instead advances in 75-minute steps. The proposed interpretation is to use all five appointment lengths when deciding whether remaining time is useful, rather than impose a fixed 75-minute sequence.

When only two hours remain and a client wants one hour, some time will remain unusable. Cadence should offer sensible placements instead of refusing the booking. The exact rule for choosing those placements is a developer decision identified in the technical summary. This protects the possibility of later bookings; it cannot guarantee that clients will fill the day.

## Necessary supporting behavior

- **Working calendar:** recurring working hours, date-specific changes, breaks or time off, and practitioner creation, rescheduling, and cancellation of appointments. Changing availability must flag existing conflicts rather than silently move booked clients. The example of 9 a.m. to 9 p.m. is illustrative, not a fixed schedule.
- **Reliable booking:** prevent overlapping appointments, including cleanup, even when two clients submit at once. A failed reschedule leaves the original appointment intact.
- **Clear cancellation boundary:** proposed interpretation is self-service at least 48 elapsed hours before the appointment’s currently scheduled start, including exactly 48 hours. Assess this before a requested change. Inside that window, direct the client to contact the practitioner. Practitioner-managed exceptions remain possible; automatic penalties are not assumed.
- **Payments and privacy:** use a card processor such as Stripe, keep private notes out of client access, and record consent to the intended use of a saved card. The user has not specified when to charge, deposits, cancellation fees, or refund rules.
- **Dependable messages:** obtain the phone number and permission needed for texts; send reminders only for current appointments. A message-delivery problem must not erase a confirmed booking.

## First release boundary

The first release should deliver this booking and management loop. Multiple practitioners or locations, group bookings, packages, memberships, waitlists, marketing campaigns, external calendar synchronization, a general form builder, and AI-based scheduling are outside the initial scope unless requested. The scheduling logic can be explicit rules rather than AI.

Success means clients know whether they have booked, returning clients retain their history and information, reminders arrive early enough to act on the cancellation policy, and the practitioner gets useful booking choices without avoidable dead time.
