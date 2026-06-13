import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["provider", "model", "apiKey", "testBtn", "testLabel", "testSpinner", "testResult"];
  static values = { savedModel: String };

  connect() {
    this.initTomSelect(this.providerTarget);
    if (this.providerTarget.value) {
      this.fetchModels(this.providerTarget.value).then(() => this.initTomSelect(this.modelTarget));
    }
  }

  disconnect() {
    this.destroyTomSelects();
  }

  providerChanged() {
    this.destroyTomSelect(this.modelTarget);
    this.modelTarget.disabled = true;
    this.modelTarget.innerHTML = '<option value="">Loading models...</option>';
    this.fetchModels(this.providerTarget.value).then(() => this.initTomSelect(this.modelTarget));
  }

  fetchModels(provider) {
    return fetch(`/users/models_for_provider?provider=${encodeURIComponent(provider)}`)
      .then((r) => r.json())
      .then((models) => {
        this.populateModels(models);
        return models;
      })
      .catch(() => {
        this.modelTarget.innerHTML = '<option value="">Failed to load</option>';
      });
  }

  populateModels(models) {
    this.modelTarget.disabled = false;
    this.modelTarget.innerHTML =
      models
        .map((m) => `<option value="${m.id}">${m.name}</option>`)
        .join("");

    const saved = this.savedModelValue;
    const match = models.find((m) => m.id === saved);
    if (match) {
      this.modelTarget.value = match.id;
    } else {
      this.modelTarget.selectedIndex = 0;
    }
  }

  testKey() {
    const provider = this.providerTarget.value;
    const apiKey = this.apiKeyTarget.value;
    const model = this.modelTarget.value;

    if (!provider || !apiKey || !model) {
      this.showResult("Please fill in provider, model, and API key.", "text-red-400");
      return;
    }

    this.setTesting(true);

    const formData = new FormData();
    formData.append("provider", provider);
    formData.append("api_key", apiKey);
    formData.append("model", model);

    fetch("/users/test_api_key", {
      method: "POST",
      headers: { "X-CSRF-Token": document.querySelector("[name='csrf-token']").content },
      body: formData,
    })
      .then((r) => r.json())
      .then((data) => {
        if (data.ok) {
          this.showResult("Connection successful", "text-emerald-400");
        } else {
          this.showResult(data.error || "Test failed", "text-red-400");
        }
      })
      .catch(() => {
        this.showResult("Connection failed", "text-red-400");
      })
      .finally(() => {
        this.setTesting(false);
      });
  }

  setTesting(testing) {
    this.testBtnTarget.disabled = testing;
    this.testLabelTarget.classList.toggle("hidden", testing);
    this.testSpinnerTarget.classList.toggle("hidden", !testing);
  }

  showResult(message, className) {
    this.testResultTarget.classList.remove("hidden", "text-emerald-400", "text-red-400");
    this.testResultTarget.classList.add(className);
    this.testResultTarget.textContent = message;
  }

  initTomSelect(el) {
    if (!this.tomInstances) this.tomInstances = new Map();
    this.tomInstances.set(el, new TomSelect(el, {
      plugins: [],
      maxOptions: 500,
      persist: false,
      create: false,
    }));
  }

  destroyTomSelect(el) {
    if (!this.tomInstances) return;
    const ts = this.tomInstances.get(el);
    if (ts) {
      ts.destroy();
      this.tomInstances.delete(el);
    }
  }

  destroyTomSelects() {
    if (!this.tomInstances) return;
    this.tomInstances.forEach((ts) => ts.destroy());
    this.tomInstances.clear();
  }
}
