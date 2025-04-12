document.addEventListener("turbo:load", function () {
  new TomSelect("#folder_feed_ids", {
    plugins: ['remove_button'],
    maxOptions: 500,
    persist: false,
    create: false
  });
});
