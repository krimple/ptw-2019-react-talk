---
title: Routing - labs
header-includes:
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[CO,CE]{\thepage}
    - \fancyfoot[LO,RE]{Chariot Solutions, 2016}
    - \fancyfoot[LE,RO]{React and Friends}
---
In this lab, we'll replace the approach of using conditional logic to alternate
between the timecard form and the list of timecards in `TimecardsView` with a
bona-fide router, the `React Router`.

## Lab Setup

1.  Install `react-router` as a build dependency with `npm`:

    ```bash
    npm install --save react-router
    ```

Now we're ready to refactor our application to using the Router API.

## Lab Steps

1.  

// actions.js

import { browserHistory } from 'react-router';


export function updateTimecard(timecard) {
  return function (dispatch) {
    axios.put(`http://localhost:3001/timecards/${timecard.id}`, timecard)
      .then(() => {
        loadTimecardsWithPromise()
          .then((timecards) => {
            dispatch({
              type: actionTypes.LOAD_TIMECARDS,
              timecards: timecards
            });
            browserHistory.goBack();  <-------  add this line after dispatching
          });
      })
      .catch((error) => {
        console.error(`An error occurred! ${JSON.stringify(error)}`);
        console.dir(error);
        alert('Update failed. Check console!');
      });
  };
}



