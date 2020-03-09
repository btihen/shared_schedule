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

        // identify element that was clicked
        var target = $el.dataset.target;
        var $target = document.getElementById(target);

        // get json data from url
        var dataURL = this.getAttribute("data-href");
        upateModalUrl(target, dataURL);

        // 'is-active' - activates / open the modal
        // 'is-clipped' allows the modal to scroll instead of background
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

  https://scotch.io/tutorials/how-to-use-the-javascript-fetch-api-to-get-data
  https://stackoverflow.com/questions/15945278/how-to-get-json-data-from-the-urlrest-api-to-ui-using-jquery-or-java-script
  function upateModalUrl(target, dataURL) {
    fetch(dataURL)
      .then(response => response.json())
      .then(data => {
        console.log('repsonse: ', data);
        document.getElementById(`${target}-body`).innerHTML = formatReservations(target, dataURL, data)
      })
      .catch(error => {
        console.error('An error ocurred: ', error);
        document.getElementById(`${target}-body`).innerHTML = formatError(target, dataURL, error)
      });
  }

  // https://scotch.io/tutorials/how-to-use-the-javascript-fetch-api-to-get-data
  // https://stackoverflow.com/questions/15945278/how-to-get-json-data-from-the-urlrest-api-to-ui-using-jquery-or-java-script
  function upateModalHtml(target, data) {
    fetch(url)
      .then(response => response.json())
      .then(data => {
        console.log('repsonse: ', data);
        document.getElementById(`${target}-body`).innerHTML = formatReservations(target, dataURL, data)
      })
      .catch(error => {
        console.error('An error ocurred: ', error);
        document.getElementById(`${target}-body`).innerHTML = formatError(target, dataURL, error)
      });
  }

  // Format Requests as Bulma HTML
  function formatError(target, dataURL, error) {
    `<ul><li>target: ${target}</li><li>URL: ${dataURL}</li><li>ERROR: ${error}</li></ul>`;
  }

  // Format Requests as Bulma HTML
  function formatReservations(target, dataURL, jsonData) {
    // https://codeblogmoney.com/convert-string-to-json-object-using-javascript/
    var firstEmail = jsonData.results[0].email
    // separate and build objects for html
    // https://stackoverflow.com/questions/12491101/javascript-create-array-from-for-loop
    var yearStart = 2000;
    var yearEnd = 2010;
    var years = [];
    while (yearStart < yearEnd + 1) {
      years.push(yearStart++);
    }
    // https://reactgo.com/javascript-loop-through-array-of-objects/
    let users = [
      { id: 1,
        name: "king" },
      { id: 2,
        name: "john" },
      { id: 3,
        name: "gowtham" }
    ]
    // first way
    users.forEach((user) => console.log(user.id, user.name));
    // second way
    for (let user of users) {
      console.log(user.id, user.name)
    }
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array
    years.forEach(function (year, index, years) {
      console.log(year, index)
    })
    // https://www.w3schools.com/js/js_json_stringify.asp
    var jsonString = JSON.stringify(jsonData);
            // https://stackoverflow.com/questions/9306476/extracting-a-string-from-a-json-object
            // var jsonData = data.getString("result");

    return `<ul><li>target: ${target}</li><li>URL: ${dataURL}</li><li>1st E-mail: ${firstEmail}</li><li>Years: ${years}</li></ul><li>Data: ${jsonString}</li></ul>`;
  }

});
