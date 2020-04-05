'use strict';

document.getElementById("newEventToggle").onclick = function () {
  var $target

  // open the new event card
  $target = document.getElementById("newEventContent");
  $target.setAttribute('class', 'card-content');

  // clear the previous event_id
  $target = document.getElementById("reservation_event_id")
  $target.selectedIndex = 0;

  // close the existing event card
  $target = document.getElementById("existingEventContent");
  $target.setAttribute('class', 'card-content is-hidden');

  // prevent form submission
  event.preventDefault();
}

document.getElementById("existingEventToggle").onclick = function () {
  var $target

  // open the existing event card
  $target = document.getElementById("existingEventContent");
  $target.setAttribute('class', 'card-content');

  // clear the form when closing
  $target = document.getElementById("reservation_event_name")
  $target.value = ''
  $target = document.getElementById("reservation_event_description")
  $target.value = ''
  // clear all sub-forms too
  $target = document.getElementById("reservation_reason_id")
  $target.selectedIndex = 0;
  $target = document.getElementById("reservation_reason_name")
  $target.value = ''
  $target = document.getElementById("reservation_reason_description")
  $target.value = ''

  // close the new event card
  $target = document.getElementById("newEventContent");
  $target.setAttribute('class', 'card-content is-hidden');

  // prevent form submission
  event.preventDefault();
}

document.getElementById("newReasonToggle").onclick = function () {
  var $target

  // open the new reason card
  $target = document.getElementById("newReasonContent");
  $target.setAttribute('class', 'card-content');

  // clear existing reasons
  $target = document.getElementById("reservation_reason_id")
  $target.selectedIndex = 0;

  // close the existing reason card
  $target = document.getElementById("existingReasonContent");
  $target.setAttribute('class', 'card-content is-hidden');

  // prevent form submission
  event.preventDefault();
}

document.getElementById("existingReasonToggle").onclick = function () {
  var $target

  // open the existing reason card
  $target = document.getElementById("existingReasonContent");
  $target.setAttribute('class', 'card-content');

  // clear the new reason form
  $target = document.getElementById("reservation_reason_name")
  $target.value = ''
  $target = document.getElementById("reservation_reason_description")
  $target.value = ''

  // close the new reason card
  $target = document.getElementById("newReasonContent");
  $target.setAttribute('class', 'card-content is-hidden');

  // prevent form submission
  event.preventDefault();
}
