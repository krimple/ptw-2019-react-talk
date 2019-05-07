---
title: Redux - labs
header-includes:
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[CO,CE]{\thepage}
    - \fancyfoot[LO,RE]{Chariot Solutions, 2016}
    - \fancyfoot[LE,RO]{React and Friends, v1.0 12/2/2016}
---

In these labs we are going to show you the power of Redux, a state management
engine driven by functional programming. Redux separates state from your components,
essentially giving your components a read-only view into the data they bind to.

The components then perform actions on the Redux store, which replaces state
based on the type of action and its payload. Finally, components that subscribe
to state changes will be notified once the store is updated, which causes them
to get new copies of their bound state.

Although this seems complicated in theory, in practice it reduces the amount
of physical wiring you have to do between components, doing away with complex
state-holding containers, and reducing mutations to a bare minimum.

We'll start by installing two libraries: `redux` and `react-redux`, a library
that makes binding Redux data to React components easy.

## Redux Lab #1: Replacing Container State with Redux

Let's install the libraries into our project with `npm`.
mechanism.

### Lab Steps

#### Adding the Libraries

1.  Make sure you're in a command-line at the root of the `timecards` project,
    and issue the following command:

    ```bash
    npm install --save redux react-redux
    ```

    The libraries are stored in `node_modules`, which makes them available to
    us in our configuration.

#### Defining action types, actions and a reducer

Now, let's set up the components of a working Redux store - a set of
action types, action creators, a reducer and the store itself.

1.  Create a directory, `src/store` in the `timecards` project. 
    We'll put our definitions in that directory.

    An _action type_ is an identifier used by Redux to define the _type_
    of action taken. Redux expects each action to contain this `type`
    property, which is usually defined using a constant string.

2.  Create a file, `src/store/actionTypes.js`, with the following
    content (we'll add more action types later in the lab):

    ```jsx
    export const COMPLETE_TIMECARD = 'COMPLETE_TIMECARD';
    ```

2.  Define a file to contain the functions that create
    your actions. These functions are known as _action creators_.  Name the
    file `actionCreators.js` and place it in `src/store`. Use the following
    definition:

    ```javascriptblack
    import {COMPLETE_TIMECARD} from './actionTypes';

    export function completeTimecard(timecard) {
      return {
        type: COMPLETE_TIMECARD,
        id: timecard.id
      };
    }
    ```

    Now we're ready to set up the reducer to handle our timecards.

#### Set up the Reducer

A reducer is a pure, stateless function that takes the previous store _state_, and an
action (which we can think of as a command) and returns a new state.  In Redux
each action either returns the previous state unchanged, or it
creates a new state object and returns it. The key here is that the
state is replaced, not mutated; a new root object is created, and there is no
internal storage of any state data. All mutations take place by accepting
input parameters and returning a new state value.

Let's build up a `timecardsReducer` function that we'll use as the
heart of our Redux store.

1.  Create another file in `src/store` called `timecardsReducer.js`.  We'll
    configure it to handle the processing of our existing functionality:
    creating the initial state and completing a timecard.  (Note: We'll leave
    sorting of timecards to another reducer, one that only holds the
    sort state).

    Edit `timecardsReducer.js` and fill it with the following (copy the
    timecards test data from the `componentDidMount()` function in
    `src/timecards/TimecardsView.js` to save time):

    ```jsx

    let initialState =  [
      ... // copy/paste the array of timecards from TimecardsView.js
    ];

    let timecardsReducer = (previousState = initialState, action) => {
      // TODO - build up reducer here
    };
    ```

    Let's build up the reducer. Typically reducers review the `type`
    property of the incoming `action`, and we have two conditions to
    deal with: first, if no type is assigned or the type is not known, and
    second, if the type is `COMPLETE_TIMECARD`.

    The first case is dealt with easily by simply returning the previous
    state.

    In the second case, the incoming timecard id is passed
    to the reducer, and we have to find it and replace the field
    `complete` with the boolean value of `true`.

    Because we always have to output a new state object, we have to
    piece it together from the elements of the prior array.

2.  Fill in the body of the `timecardsReducer` function like this:

    ```jsx
    switch(action.type) {
        case COMPLETE_TIMECARD:
          let idx = previousState.findIndex((tc) => tc.id === action.id);
          if (idx > -1) {
            return [
              ...previousState.slice(0, idx),
              { ...previousState[idx], complete: true },
              ...previousState.slice(idx + 1, previousState.length)];
          } else {
            return previousState;
          }
        default:
          return previousState;
    }
    ```

#### Reducer logic review

That reducer operation looks pretty complex. But let's break it down:

```jsx
...previousState.slice(0, idx),
    
```

We are filling in an array starting with the entries
of the previous state before the completed timecard,
using destructuring to expand them in place.

The `Array.prototoype.slice` function returns a slice of 
an array, without manipulating the source array. The first
parameter is the starting location, and the second parameter
is the ending position,  which is _not included_.

```jsx
{ ...previousState[idx], complete: true },
```

This expression creates a new object to represent the replaced
timecard, copies all properties into the new object 
from the previous state for the completed time card with the
same keys and values.  Then it overwrites the `complete`
property with the value of `true`. This can only be issued
in a project that supports ES2016 object destructuring.

```jsx
...previousState.slice(idx + 1, previousState.length)]
```

and finally we get the rest of the array.

Though the expression is complex, we have a way to test it. Built in to
the `create-react-app` project starter is the testing engine,
`JEST`.  We can create a unit test alongside our reducer and run
it with `npm test`.

#### Testing our Reducer

Reducer logic can be complex. To run it, however, you only need to stand
up a unit test. Data in, data out! Let's try it.

1.  Create a unit test file, `timecardsReducer.test.js`, in the
    `src/store` directory. Fill in the contents with this:

    ```jsx
    import timecardsReducer from './timecardsReducer';
    import * as actions from './actions';

    describe('Timecards reducer', () => {

      let defaultState;

      beforeEach(() => {
        defaultState = timecardsReducer(undefined, {});
      });


      it('should contain timecards in the initial state', () => {
        expect(defaultState.length).toBe(3);
      });

    });
    ```

2.  Run the test with `npm test` and make sure the test passes. The
    test checks to make sure we have three timecards in the initial
    state of the reducer.

    Now, let's add another test to make sure we can complete a
    timecard. 

2.  Add the following function before the last line of the
    definition:

    ```jsx
    it('should complete a timecard', () => {
      // make sure our test state has an uncompleted
      // timecard in slot 0
      defaultState[0].complete = false;

      // now exercise the reducer
      let newState = timecardsReducer(defaultState,
        actions.completeTimecard(defaultState[0]));

      expect(newState[0].complete).toBe(true);
    });
    ```

It helps to test your reducers, especially with logic that
manipulates arrays.  Make sure this test passes, and once it does,
you may move on to the next step.

#### Create and wire the Redux store

Reducers aren't useful unless they are installed in Redux stores. A store handles
the dispatching of actions to its reducers, and allows for subscribing to the
state that the stores are providing. It also provides lifecycle hooks for tasks
such as logging and debugging.

Let's install the reducer in a Redux store, so we can use it.

1.  Create a directory off of `src` named `store`.  In that
    directory, create a file, `configureStore.js`, and fill with the
    following content:

    ```jsx
    import { createStore, combineReducers } from 'redux';
    import timecardsReducer from './timecardsReducer';

    const configureStore = () => {
      return createStore(
        combineReducers({
          timecards: timecardsReducer
        })
      );
    };

    export default configureStore;
    ```

    The store will configure our reducer and make it available to our
    components. Now let's install the store in our application.

    The `react-redux` library provides several mechanisms for wiring a Redux store
    into an application and injecting content from that store into its components.

1.  Edit `src/App.js`.  Add the following imports:

    ```jsx
    import { Provider } from 'react-redux';
    import configureStore from './store/configureStore'
    ```

    And add the `Provider` component, wrapping it around the outer application
    `div` in the `render()` method:

    ```jsx
    <Provider store={store}>
      <div>
        <Header />
        <TimecardsView />
      </div>
    </Provider>
    ```

Now we'll use the store in the components that need it. In previous labs,
we provided the `timecards` collection in the `TimecardsView` component.
Using Redux, we instead will inject the state of the container in whatever
component needs to use it. Let's remove the `props` settings in the
`TimecardsView` component.

#### Configure TimecardsView, TimecardsViewHeader, TimecardTable and Timecard

Since the `TimcardsView` component in `src/timecards` doesn't really need to deal with
passing props anymore, it can be converted to a _functional_ or stateless component.

1.  Change the definition to look like this:

    ```jsx
    import React from 'react';
    import TimecardsViewHeader from './TimecardsViewHeader';
    import TimecardsTable from './TimecardsTable';

    const TimecardsView = () => {
     return (
       <div className="container">
         <TimecardsViewHeader />
         <TimecardsTable />
       </div>
     );
    };

    export default TimecardsView;
    ```

2.  Now we'll edit `TimecardsViewHeader.js` in `src/timecards`, and use the
    `connect` method of `react-redux` to pull the count of timecards into
    the header. Start by adding the `connect` import at the top:

    ```jsx
    import { connect } from 'react-redux';
    ```

    Leave the constructor and `doSort` functions alone; we still need to add
    another reducer to deal with sorting keys. We need to use `connect` to
    wire the component into the Redux engine. Remove the `export default`
    from the class definition:

    ```jsx
    class TimecardsViewHeader extends Component {
    ```

    After the class definition in the file, add a stand-alone function,
    `mapStateToProps`. This function is called by `connect` to map _Redux_ state
    to _React_ props, and will pluck the row count out of the Timecards reducer.

    ```jsx
    function mapStateToProps(state, ownProps) {
      return {
        numRows: state.timecards.length
      };
    }
    ```

    Finally, add another line below the function to wrap the `TimecardsViewHeader`
    component with the Redux provider:

    ```jsx
    export default connect(mapStateToProps)(TimecardsViewHeader);
    ```

2.  Next, we'll set up the `TimecardsTable` component to use Redux. Use the same
    imports:

    ```jsx
    import {connect} from 'react-redux';
    ```

    Don't forget to remove the `export default` from the class definition.
    This is a common mistake and will cause you to scratch your head for
    a long time, wondering why the `mapStateToProps` method below never gets
    called...

    ```jsx
    class TimecardsTable
    ```

    Like the original non-Redux version, we're going to pull the `timecards`
    from the `props` collection of the component. However, when the table is
    first rendered, the `timecards` collection won't exist.  We need to adjust
    our render method to handle this state.  Add this to the top of the method:

    ```jsx
    render() {
      if (!this.props.timecards) {
        return <div>Please wait...</div>;
      }
    }
    ```

    Next, we can reduce the complexity of the `TimecardTableRow` mapping,
    since any actions we will make will use Redux, and not a container, to
    process.  Remove all but the `id` and `timecard` properties.

    ```jsx
    return (
      <TimecardTableRow
        key={timecard.id}
        timecard={timecard} />
    );
    ```

    And now we have to map our Redux collection, `timecards`, to our props.
    Add the following to the end of the file (after the class definition):

    ```jsx
    function mapStateToProps(state, ownProps) {
      return {
        timecards: state.timecards
      };
    }

    export default connect(mapStateToProps)(TimecardsTable);
    ```

2.  Now, we'll adjust our `TimecardTableRow` component to allow us to complete
    a timecard.  Add the following imports:

    ```jsx
    import {bindActionCreators} from 'redux';
    import {connect} from 'react-redux';
    import * as actions from '../store/actions';
    ```

2.  Again, remove the `export default` in the class definition:

    ```jsx
    class TimecardTableRow extends Component {
    ```

    We can keep the constructor and the `doCompleteTimecard` method, but we
    will need to change the guts of the function. 

2.  Change `doCompleteTimecard` to:

    ```jsx
    doCompleteTimecard() {
      this.props.actions.completeTimecard(this.props.timecard);
    }
    ```

2.  Add the mapping code to map action creators to our component.

    ```jsx
    function mapDispatchToProps(dispatch) {
      return {
        actions: bindActionCreators(actions, dispatch)
      };
    }
    ```

    That function allows the component to call action creator functions
    in the `actions.js` file (such as `completeTimecard`) and dispatches the
    calls to Redux automatically when called.

2.  Finalize the wiring with `component`:

    ```jsx
    export default connect(null, mapDispatchToProps)(TimecardTableRow);
    ```

2.  Now, test the application. If you get stuck make sure to open up the
    console and set breakpoints.

## Redux Lab #2: Adding Redux middleware

Redux provides middleware for tasks such as tracking changes or even debugging.

Let's install a middleware tool, the `redux-logger`.

### Lab Steps

1.  Install the middleware with the `npm install` command:

    ```bash
    npm install --save redux-logger
    ```

2.  Use the middleware in the `configureStore.js` file in `src/store`. Modify
    your imports to:

    ```jsx
    import { createStore, combineReducers, applyMiddleware } from 'redux';
    import createLogger from 'redux-logger';
    import timecardsReducer from './timecardsReducer';
    ```

2.  Create the logger by calling the function:

    ```jsx
    let logger = createLogger();
    ```

2.  Modify your `configureStore` function to use the new `combineMiddleware`
    function and insert your logger as the second parameter of `createStore`:

    ```jsx
    const configureStore = () => {
      return createStore(
        combineReducers({
          timecards: timecardsReducer
        }),
        applyMiddleware(logger)
      );
    };
    ...
    ```

Now, refresh your browser and open up the console.  Every time you click on
a complete button, you'll get diagnostic logging output in the browser console.

Here is an example:

```text
core.js:99  action @ 15:57:12.678 COMPLETE_TIMECARD
core.js:111  prev state Object {timecards: Array[3]}
core.js:115  action Object {type: "COMPLETE_TIMECARD", id: 3}
core.js:123  next state Object {timecards: Array[3]}
```

## Redux Lab #4: Sorting timecards in Redux

Now we are ready to deal with the sorting feature in our TimecardsViewHeader.
We didn't deal with it before, because we wanted to get a single store configured
completely from end-to-end.

#### How to sort?

The first question is, where could sorting live?  There are several options:

* You could sort in the reducer, adding the sort key as a property and causing it
  to violate the single responsibility principal.
* You could sort in the component, taking the `timecards` Redux state variable and
  deriving a further sorted version in `mapStateToProps`
* You could sort in the component, while keeping the sort key in a Redux state
  variable. This allows you to share the sort key across the system (if needed),
  while doing the actual sort activity inside of the component itself.

We are taking the third approach here, putting the sort key in a separate reducer
state, while sorting the data itself in the component.

### Lab Steps

1.  Let's create a key to recognize a change in sorting parameters in the 
    `actionTypes.js` file:

    ```jsx
    export const SET_SORT_KEY = 'SET SORT KEY';
    ```

2.  Now that we have several actions, refactor the action creators in `actions.js`    and import all action types using destructuring: 

    ```jsx
    import * as actionTypes from './actionTypes';  <-- new

    export function completeTimecard(timecard) {
      return {
        type: actionTypes.COMPLETE_TIMECARD,
        id: timecard.id
      };
    }

    export function setSortKey(sortKey) {   <-- new
      return {
        type: actionTypes.SET_SORT_KEY,
        key: sortKey
      }
    }
    ```

2.  Create another reducer in the directory `src/store`, with the file name of
    `uiSettingsReducer.js`:

    ```jsx
    import { SET_SORT_KEY } from './actionTypes';

    let initialState = { sortKey:  'description'};
    let uiSettingsReducer = (previousState = initialState, action) => {
      switch (action.type) {
        case SET_SORT_KEY:
          return {sortKey: action.key};
        default:
          return previousState;
      };
    };

    export default uiSettingsReducer;
    ```

2.  Now, add the reducer to your Redux store. Edit `configureStore.js` in 
    `src/store` and add the `uiSettings` property, pointing to an imported
    reducer function:

    ```jsx
    import uiSettingsReducer from './uisSetttingsReducer';
    ...

        return createStore({
            combineReducer({
                timecards: timecardsReducer,
                uiSettings: uiSettingsReducer   <--new
            }),
            combineMiddleware(logger)
        );
    ...
    ```

#### Using the new Reducer

Now we'll wire up the new action creator to our `TimecardsViewHeader` component
to replace the original state-based sorting functionality.

1.  In `TimecardsViewHeader.js`, wire in the call to the action to trigger
    the sort setting:

    ```jsx
    ...
    import { bindActionCreators } from '../store/actions';
    import * as actions from '../store/actions';
    ...

    class TimecardsViewHeader extends Component {
        ...

        doSort(event) {
          this.props.action.setSortKey(event.target.value);   <-- new: use action
        }

    }

    ...

    function mapDispatchToProps(dispatch) {
        return {
            actions: bindActionCreators(actions, dispatch);
        }
    }

    export default connect(mapStateToProps, mapDispatchToProps)
                          (TimecardsViewHeader);
    ```

    Note - you are adding the `mapDispatchToProps` but leaving the 
    `mapStateToProps` function intact.

    Finally, we'll connect the sorting feature to the `TimecardsTable`
    component. Every time a sort change is recieved, we'll re-sort the
    timecards from the Redux store and place the sorted version in the
    component's props.

2.  Edit `TimecardsTable.js` and replace the existing `mapStateToProps` method:

    ```jsx
    function mapStateToProps(state, ownProps) {
      // if we do have a sort key, re-sort
      let sortedTimecards;
      let key = state.uiSettings.sortKey;
      if (key) {
        sortedTimecards = state.timecards.concat().sort((tc1, tc2) => {
          return tc1[key] > tc2[key] ? 1 : -1;
        });
      } else {
        sortedTimecards = state.timecards;
      }

      return {
        timecards: sortedTimecards
      };
    }
    ```

2.  Now, refresh and run the browser. Select each field and see how the table 
    automatically sorts.

## Wrap-up

You've seen in this lab how React and Redux work together. Redux manages a
store of state data, injected into React components via the `connect` method
of `react-redux` and configured using the `react-redux` `Provider` component.
Finally, two methods are extremely useful in configuring redux: `mapStateToProps`,
a mapping method that allows various elements of Redux state to be projected
as properties in a component, and `mapDispatchToProps`, a mapping method that
binds action creators to the Redux state store.


