---
title: Ajax - Lab
header-includes:
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[CO,CE]{\thepage}
    - \fancyfoot[LO,RE]{Chariot Solutions, 2016}
    - \fancyfoot[LE,RO]{React and Friends}
---
In this lab we'll see how to use Ajax and the `thunk` library to provide a form process for the Timecard application.

There are many third-party libraries available to handle forms processing, but for this example we'll just stick with basic form events. The main goal of the lab is to show how async Ajax actions in redux can be used to keep the data in sync with a REST API.

We're going to use several additional APIs:

* `thunk` - again, this library is used to update a Redux store after a process completes
* `axios` - an Ajax library that provides a good baseline of features we'll need to communicate with a RESTful server
* `JSON Server` - a great test REST server for building your front-end. Provides all of the basic REST APIs and data in a simple, JSON-based data store


## Setup

1.  Install the libraries into your project

    ```bash
    npm install --save axios redux-thunk
    npm install --save react-bootstrap
    npm install --save react-bootstrap-date-picker
    npm install --save-dev json-server
    ```

2.  Copy the seed database file, `db.json`, from `snippets` and place in your project's root directory.

2.  Add the following to your `scripts` section of `package.json`:

    ```text
    "server": "./node_modules/.bin/json-server db.json --port 3001",
    ```

2.  Verify the server works by issuing

    ```text
    npm run server
    ```

2.  Test the server by browsing to ` http://localhost:3001/timecards` in your browser.

Leave the server running in a console while you complete the next tasks in the lab.

## Lab Steps

We'll begin by setting up the loading process.  

1.  Fire up your server in another terminal with `npm start` if it
    isn't running already.

    ```text
    npm start
    ```

2.  Copy the `TimecardForm.js` file from `timecard-solutions/snippets/
    ajax-redux-lab` and place it in `src/timecards`. This form has been
    pre-wired to edit a timecard and deal with basic validation errors.

### Setting up the Reducer and Action Types

We are going to set up a reducer to handle the form management for
the `TimecardForm`. This reducer will contain the starting state of the 
form data.

1.  Create a file, `timecardFormReducer.js`, in `src/store`. Fill in 
    with the following definition:

    ```javascriptblack
    import { LOAD_TIMECARDS } from './actionTypes';
    import { EDIT_TIMECARD } from './actionTypes';
    import { CLEAR_FORM } from './actionTypes';
    let timecardFormReducer = (previousState = null, action) => {
      switch(action.type) {
        case LOAD_TIMECARDS:
          return null;
        case EDIT_TIMECARD:
          return { ...action.timecard };
        case CLEAR_FORM:
          return null;
        default:
          return previousState;
      }
    };
    ```

    Perhaps counter-intuitively, we're clearing out our form when
    we load timecards - because a load was triggered, we are 
    no longer editing one.

    If we send an action request for `EDIT_TIMECARD`, we are filling in
    the state of the form with the contents of the passed timecard. If
    we submit the form, we load the timecards to refresh them. We're leaving the `CLEAR_FORM` state in the reducer in case you want to
    implement a cancel button later.

2.  In `src/store/configureStore.js`, add the reference to the new 
    reducer by adding a reference and the new key to `combineReducers`:

    ```javascriptblack
    ...
    import timecardFormReducer from './timecardFormReducer';
    ...

         return createStore(
            combineReducers({
              timecards: timecardsReducer,
              uiSettings: uiSettingsReducer,
              timecardForm: timecardFormReducer  <-- new
            }),
            applyMiddleware(thunk, logger)
          );
    ...
    ```

2.  Add the following keys to `actionTypes.js` in 'src/store' to 
    reflect our new reducer's keys.

    ```javascriptblack
    export const LOAD_TIMECARDS = 'LOAD_TIMECARDS';
    export const EDIT_TIMECARD = 'EDIT_TIMECARD';
    export const CLEAR_FORM = 'CLEAR_FORM';
    ```

### Setting up the Action Creators

Now, let's do the heavy lifting for using Ajax in Redux. 
We'll do our work in `actions.js` in `src/store`. 

1.  Add an import of Axios to the end of your imports in `actions.js`:

    ```javascriptblack
    import * as axios from 'axios';
    ```

2.  Just below that, we'll add a helper function, one that fetches
    the data for all timecards. We're going to use that a lot, so
    we should write it one time:

    ```javascriptblack
    function loadTimecardsWithPromise() {
      return axios.get('http://localhost:3001/timecards')
        .then((payload) => {
          return payload.data;
        })
        .then((timecards) => {
          return timecards.map((timecard) => {
            return {
              ...timecard,
              date: new Date(timecard.date)
            }
          })
        });
    }
    ```

    The code above uses _promise chaining_ to transform the 
    output from the server. First, it comes in as an `ajax`
    `data` parameter, a raw JavaScript object parsed from JSON.

    We return that data parameter from the promise, then _immediately
    chain another `.then` method_. This is the way to execute _another_
    transform of the data. We are using that second `.then` method
    to parse the raw date, and place the timecard in a new object
    shell with a real date, rather than a string.

    The final promise generated by this mapping is then returned
    from the function, so we can use it to prep fetching of timecards
    during load and after saving changes to an existing timecard.

2.  Now, we're going to set up the loading of timecards with the
    `loadTimecards()` method. Add the following action creator
     to `actions.js`:

    ```javascriptblack
    export function loadTimecards() {
      return function(dispatch) {
         loadTimecardsWithPromise()
         .then((timecards) => {
            dispatch({
              type: actionTypes.LOAD_TIMECARDS,
              timecards: timecards
            });
          })
          .catch((error) => {
            console.error(`An error occurred! ${JSON.stringify(error)}`);
            console.dir(error);
            alert('Fetch failed. Check console!');
          });
      };
    }
    ```

    The method above uses the `redux-thunk` middleware to 
    asynchronously dispatch a method in Redux.  It starts by
    asking Axios to return and map the `timecards` collection,
    and it then dispatches a call to the store for any reducer
    that wants to respond to the `LOAD_TIMECARDS` action.

    This is the action we've put together in our new store, which
    then gets and stores the `timecard` as its state.

### Providing actions for enabling editing, updating and completing Timecards

In this section we'll add the actions we need to process timecards.

First, we need to trigger the state that causes the `TimecardsView` to display
our form. 

1.  Add the following simple synchronous action to `actions.js`:

    ```javascriptblack
    export function editTimecard(timecard) {
      return {
        type: actionTypes.EDIT_TIMECARD,
        timecard: timecard
      };
    }
    ```

    This causes the Redux subscribers to update, including `TimecardsView`,
    which causes it to show the timecard passed in the form.

2.  Next, we need a way to update a timecard when we save our form. That's the
    job of `updateTimecard` - add it to the `actions.js` file:

    ```javascriptblack
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
              });
          })
          .catch((error) => {
            console.error(`An error occurred! ${JSON.stringify(error)}`);
            console.dir(error);
            alert('Update failed. Check console!');
          });
      };
    }
    ```

    This method is similar to the one before in retrieve, except now we're using
    the `HTTP PUT` method to update the resource on the server.  We then trigger
    a reload of the entire state with a call to `loadTimecardsWithPromise`. 
    Ultimately, we dispatch a `LOAD_TIMECARDS` request, which replaces the state
    in the `timecards` reducer, and clears the form in the `timecardsForm` reducer.

    Let's fixup the `completeTimecard` method from the earlier lab. now delegating
    a call to the `updateTimecard` action creator.

2.  Edit `actions.js` and add the following function:

    ```javascriptblack
    export function completeTimecard(timecard) {
      timecard.complete = true;
      return updateTimecard(timecard);
    }
    ```

2.  Finally, in case you implement a `reset` button and want to just cancel
    a form edit, let's add this function to `actions.js`:

    ```javascriptblack
    export function clearForm() {
      return {
        type: actionTypes.CLEAR_FORM
      };
    }
    ```

### Wiring Components to our new Redux Actions

We've already configured Redux for use in our application in the prior lab.
Now we'll begin to add editability to the timecards using our new class,
`TimecardForm`.  

Let's start by editing the component that exposes the `Edit` button,
`TimecardTableRow.js` in `src/timecards`.

1.  Edit `TimecardTableRow.js` and add a new button before the 
    `Complete` button:

    ```jsxblack
    <tr key={timecard.id}>
      <td>{ timecard.date.toDateString() }</td>
      ...
      <td>{ timecard.project }</td>

      <td>
        <button className="btn btn-sm btn-primary"  <-- new
            onClick={this.doEditTimecard}>          <-- new
            Edit                                    <-- new
        </button>                                   <-- new
        <button className="btn btn-sm btn-danger"
            disabled={this.props.timecard.complete}
            onClick={this.doCompleteTimecard}>
            Complete!
        </button>
      </td>
    </tr>
    ```

    We'll need to build and wire up the `doEditTimecard` method.

2.  Add the method to the `TimecardTableRow.js` file:

    ```javascript
    doEditTimecard(){
        this.props.actions.editTimecard(this.props.timecard);
    }
    ```

    The method comes from our wiring up of the dispatcher actions
    in the previous lab. We're automatically adding all actions in
    `actions.js` as the property `actions` in `props`.

2.  Add the bind method for the new `doEditTimecard` function to
    the constructor:

    ```javascriptblack
    constructor(props) {
        super(props);
        this.doCompleteTimecard = this.doCompleteTimecard.bind(this);
        this.doEditTimecard = this.doEditTimecard.bind(this);  <-- new
    }
    ```

### Wiring up the form to the `TimecardsView` component

This is the final step: we need to display the TimecardForm whenever the reducer
sees a value in `timecard`.  

1.  Open up `TimecardsView` and add the following imports:

    ```javascriptblack
    import { connect } from 'react-redux';
    import TimecardForm from './TimecardForm';
    ```

2.  IMPORTANT - remove `export default` from the `TimecardsView` function
    definition (this is a functional component).  

     ```jsxblack
    const TimecardsView = (props) => {  <-- modify this line
      ...
    }
    ```

    We didn't use a `props` parameter before, because the component didn't 
    manage any state. Now we will, in that we'll introspect the state of the 
    Redux store's `timecardForm` key to figure out whether to show or hide 
    form or the table and header.

    We'll export the function a bit later.

2.  After the class definition, add the `mapStateToProps` method and the
    `connect` method call:  

    ```jsxblack
    function mapStateToProps(state, ownProps) {
      return {
        isEditing: state.timecardForm !== null,
        timecardForm: state.timecardForm
      }
    }
    export default connect(mapStateToProps)(TimecardsView);
    ```

    As you can see, we are _deriving_ the values `isEditing` and
    `timecardForm` from the value of the state in Redux. This is normal,
    and anything you _can_ derive from existing data, you should consider
    deriving.

2.  Test it!  Run the application and debug it until your application works.

## Review

In this lab, we've installed the `redux-thunk` middleware, and used it to provide
asynchronous action dispatches from action creators.  In those action creators,
we've called AJAX with Axios, a simple HTTP client. The wiring involved to get
various components to talk to each other is simplified by the addition of Redux,
since Redux notifies and coordinates changes to the state of the application, and components need not propagate callback methods downward to target components anymore.

