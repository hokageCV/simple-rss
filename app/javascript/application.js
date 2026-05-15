// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const dialog = document.getElementById("turbo-confirm-dialog")
const messageElement = document.getElementById("turbo-confirm-message")
const confirmButton = dialog?.querySelector("button[value='confirm']")

Turbo.config.forms.confirm = (message, element, submitter) => {
  if (!dialog) return Promise.resolve(confirm(message))

  messageElement.textContent = message

  const buttonText = submitter?.dataset.turboConfirmButton || "Confirm"
  confirmButton.textContent = buttonText

  dialog.showModal()

  return new Promise((resolve) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue === "confirm")
    }, { once: true })
  })
}
