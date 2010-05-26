document.observe("dom:loaded", function() {
  var firstField = $$('input[type=text]').first();
  if (firstField) {
    firstField.activate();
  }
})