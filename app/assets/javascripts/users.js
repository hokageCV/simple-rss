document.addEventListener("turbo:load", function () {
  var select = document.querySelector("#feed-type-select");
  if (select) {
    new TomSelect(select, {
      plugins: ['remove_button'],
      maxOptions: 10,
      persist: false,
      create: false
    });
  }
});
