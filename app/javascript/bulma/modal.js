'use strict';

// https://siongui.github.io/2018/09/27/vuejs-bulma-modal/
// https://siongui.github.io/2018/02/11/bulma-modal-with-javascript/

document.addEventListener('DOMContentLoaded', function () {

  // Modals
  var rootEl = document.documentElement;
  var $modals = getAll('.modal');
  var $modalButtons = getAll('.modal-button');
  var $modalCloses = getAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button');

  if ($modalButtons.length > 0) {
    $modalButtons.forEach(function ($el) {
      $el.addEventListener('click', function () {

        // figure out where was clicked
        var target = $el.dataset.target;
        var $target = document.getElementById(target);

        // jQuery - https://www.codexworld.com/bootstrap-modal-dynamic-content-jquery-ajax-php-mysql/
        // gather data to display in modal from 'data-href' clicked i.e.: "tenant/1/space/1?date=2020-12-20"
        var dataURL = this.getAttribute("data-href");
        var url = 'https://randomuser.me/api/?results=10'; // Get 10 random users

        // https://scotch.io/tutorials/how-to-use-the-javascript-fetch-api-to-get-data
        // https://stackoverflow.com/questions/15945278/how-to-get-json-data-from-the-urlrest-api-to-ui-using-jquery-or-java-script
        var html = fetch(url)
          .then(response => response.json())
          .then(data => {
            console.log('got it:', data);
            document.getElementById(`${target}-body`).innerHTML =
              `<ul><li>target: ${target}</li><li>URL: ${dataURL}</li><li>URL: ${data}</li></ul>`;
          })
          .catch(error => {
            console.error('An error ocurred', error); 
            document.getElementById(`${target}-body`).innerHTML =
              `<ul><li>target: ${target}</li><li>URL: ${dataURL}</li><li>URL: ${error}</li></ul>`;
          });

        // assign the html to the correct modal
        // document.getElementById(`${target}-body`).innerHTML = `<ul><li>target: ${target}</li><li>URL: ${dataURL}</li><li>URL: ${html}</li></ul>`;

        // change the modal to 'is-active' - open modal
        rootEl.classList.add('is-clipped');
        $target.classList.add('is-active');
      });
    });
  }

  if ($modalCloses.length > 0) {
    $modalCloses.forEach(function ($el) {
      $el.addEventListener('click', function () {
        closeModals();
      });
    });
  }

  document.addEventListener('keydown', function (event) {
    var e = event || window.event;
    if (e.keyCode === 27) {
      closeModals();
    }
  });

  function closeModals() {
    rootEl.classList.remove('is-clipped');
    $modals.forEach(function ($el) {
      $el.classList.remove('is-active');
    });
  }

  // Functions
  function getAll(selector) {
    return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
  }

});
