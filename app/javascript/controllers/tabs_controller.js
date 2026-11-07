import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list", "tab", "panel"];
  static values = { initial: String };

  connect() {
    const selected = this.tabTargets.find((tab) => tab.getAttribute("aria-selected") === "true") ||
      this.tabTargets.find((tab) => tab.getAttribute("aria-controls") === this.initialValue) || this.tabTargets[0];
    this.activate(selected);
    this.listTarget.hidden = false;
  }

  select(event) {
    this.activate(event.currentTarget);
  }

  navigate(event) {
    const index = this.tabTargets.indexOf(event.currentTarget);
    const last = this.tabTargets.length - 1;
    const positions = {
      ArrowLeft: index === 0 ? last : index - 1,
      ArrowRight: index === last ? 0 : index + 1,
      Home: 0,
      End: last,
    };
    if (!(event.key in positions)) return;

    event.preventDefault();
    const tab = this.tabTargets[positions[event.key]];
    this.activate(tab);
    tab.focus();
  }

  activate(selected) {
    if (!selected) return;
    this.tabTargets.forEach((tab) => {
      const active = tab === selected;
      tab.classList.toggle("tab-active", active);
      tab.setAttribute("aria-selected", String(active));
      tab.tabIndex = active ? 0 : -1;
    });
    this.panelTargets.forEach((panel) => {
      panel.hidden = panel.id !== selected.getAttribute("aria-controls");
    });
  }
}
