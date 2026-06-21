import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['checkbox', 'output', 'copyBtn', 'selectAll']

  connect() {
    this.outputTarget.classList.add('hidden')
  }

  toggleAll(event) {
    const checked = event.target.checked
    this.checkboxTargets.forEach(cb => cb.checked = checked)
  }

  generate() {
    const urls = this.checkboxTargets
      .filter(cb => cb.checked)
      .map(cb => cb.value)

    if (urls.length === 0) return

    this.outputTarget.value = urls.join('\n')
    this.outputTarget.classList.remove('hidden')
    this.copyBtnTarget.classList.remove('hidden')
    this.outputTarget.focus()
    this.outputTarget.select()
  }

  copy() {
    const textarea = this.outputTarget
    textarea.select()
    navigator.clipboard.writeText(textarea.value)

    const original = this.copyBtnTarget.innerHTML
    this.copyBtnTarget.innerHTML = `
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
      </svg>
      Copied!
    `
    this.copyBtnTarget.classList.remove('border-accent/30', 'text-accent')
    this.copyBtnTarget.classList.add('border-emerald-500/30', 'text-emerald-400')

    setTimeout(() => {
      this.copyBtnTarget.innerHTML = original
      this.copyBtnTarget.classList.remove('border-emerald-500/30', 'text-emerald-400')
      this.copyBtnTarget.classList.add('border-accent/30', 'text-accent')
    }, 2000)
  }
}
