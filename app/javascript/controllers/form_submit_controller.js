import { Controller } from "@hotwired/stimulus";

// Handles native submissions and Turbo's lifecycle without disabling the submitter's name/value.
export default class extends Controller {
  static targets = ["spinner", "status"];

  connect() {
    this.originalStatus = this.hasStatusTarget ? this.statusTarget.textContent : "";
  }

  start(event) {
    if (this.submitting) {
      event.preventDefault();
      return;
    }

    queueMicrotask(() => {
      if (!event.defaultPrevented) this.showPending(event.submitter);
    });
  }

  turboStart(event) {
    this.showPending(event.detail.formSubmission.submitter);
  }

  showPending(submitter) {
    if (this.submitting) return;
    this.submitting = true;
    this.submitter = submitter;
    this.submitter?.setAttribute("aria-busy", "true");
    this.submitter?.setAttribute("aria-disabled", "true");
    this.submitter?.classList.add("cursor-wait");
    if (this.hasSpinnerTarget) this.spinnerTarget.classList.remove("invisible");
    if (this.hasStatusTarget) this.statusTarget.textContent = this.statusTarget.dataset.message || "Submitting…";
  }

  reset() {
    this.submitting = false;
    this.submitter?.removeAttribute("aria-busy");
    this.submitter?.removeAttribute("aria-disabled");
    this.submitter?.classList.remove("cursor-wait");
    if (this.hasSpinnerTarget) this.spinnerTarget.classList.add("invisible");
    if (this.hasStatusTarget) this.statusTarget.textContent = this.originalStatus;
    this.submitter = null;
  }
}
