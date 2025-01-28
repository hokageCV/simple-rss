import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="read"
export default class extends Controller {
  static targets = ['summary', 'playPauseBtn']

  connect() {
    this.isPaused = false
    this.speech = null
  }

  getContent() {
    window.speechSynthesis.cancel()

    if (this.hasSummaryTarget) {
      const content = this.summaryTarget.innerText
      this.playPauseBtnTarget.style.display = 'inline-block'
      this.startSpeech(content)
    }
  }

  startSpeech(content) {
    this.speech = new SpeechSynthesisUtterance(content)

    this.speech.pitch = 1;
    this.speech.rate = 2;
    this.speech.volume = 1;

    window.speechSynthesis.speak(this.speech)

    this.speech.onpause = () => {
      this.isPaused = true
      this.updatePlayPauseButton()
    }

    this.speech.onresume = () => {
      this.isPaused = false
      this.updatePlayPauseButton()
    }

    this.speech.onend = () => {
      this.isPaused = false
      this.updatePlayPauseButton()
    }
  }

  pauseSpeech() {
    window.speechSynthesis.pause()
    this.isPaused = true
  }

  resumeSpeech() {
    window.speechSynthesis.resume()
    this.isPaused = false
  }

  togglePlayPause() {
    if (this.isPaused) {
      window.speechSynthesis.resume()
      this.isPaused = false
      this.updatePlayPauseButton()
    } else {
      window.speechSynthesis.pause()
      this.isPaused = true
      this.updatePlayPauseButton()
    }
  }

  updatePlayPauseButton() {
    const button = this.playPauseBtnTarget;
    button.innerText = this.isPaused ? "\u25B6" : "\u23F8";
  }
}
