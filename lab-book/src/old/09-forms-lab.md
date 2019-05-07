---
title: Forms - labs
header-includes:
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[CO,CE]{\thepage}
    - \fancyfoot[LO,RE]{Chariot Solutions, 2016}
    - \fancyfoot[LE,RO]{React and Friends}
---
# Forms Lab #1 - Adding sorting capability

In this lab, we'll begin working with form fields to trigger changes to our
model. We'll add a sorting option to the `TimecardsViewHeader` component, and
use it to execute a sort mechanism in the state-holding `TimecardsView` container
component.

We'll have more sophisticated form processing in a later chapter, but for now
this gets us started handling events and accepting input from fields.

## Steps

1.  Open the `TimecardsViewHeader` component in `src/timecards`.  First, add a
    class method, `doSort`, which gets called whenever we select a different
    field to sort by:

    ```javascriptblack
    doSort(event) {
      this.props.sortByField(event.target.value);
    }
    ```

    Form fields can generate events, such as `onChange`. These events provide
    an `event` parameter, which will contain the target of the event (in our
    case, an HTML select control), which will provide a `value` property. It is
    the `value` property that will be sent to the `sortBy` method, which we will
    create later. It is this `sortBy` method in the `TimecardsView` component that
    actually will sort the data stored in state.

2.  Now edit the `render()` method. We're going to wrap the original Bootstrap grid
    row that contained the message `n timecards`, because a React component must always
    render a _single_ component. Our easy out? Render an outer `div`. We'll end up
    with two rows at the top of the header - one for the count, and another with
    a `select` control:

    ```javascriptblack
    render() {
     return (
       <div className="row">
         <div className="col-xs-3">{ this.props.numRows } timecards</div>
         <select onChange={this.doSort}>
           <option value="billable">Billable</option>
           <option value="date">Date</option>
           <option value="description">Description</option>
           <option value="hours">Hours</option>
           <option value="project">Project</option>
         </select>
       </div>
     );
    }
    ```

2.  Finally, we need to make sure we bind the `this` keyword properly to the
    `TimecardsView` component.

    ```javascriptblack
    constructor(props) {
      super(props);
      this.doSort = this.doSort.bind(this);
    }
    ```
  Now we need to switch over to the `TimecardsView` component and set up the
  `sortBy` method and perform our sort.

2. Edit `TimecardsView.js` in `src/timecards`.  Define a method, `sortByField`:

    ```javascriptblack
    sortByField(key) {
      // get out if not a valid key
      if (key === '---') return;

      let sortedTimecards = this.state.timecards.concat().sort((tc1, tc2) => {
           return tc1[key] > tc2[key] ? 1 : -1;
       });

       this.setState({
         timecards: sortedTimecards
       });
    }
    ```

    This method takes a field name, and uses it to sort the `timecards`
    collection in the container component. Because we're setting the state
    at the end, overwriting the existing `timecards` with our `sortedTimecards`
    collection, the changes flow downward, forcing the re-rendering of our
    `TimecardsTable`.

    But we're not done yet. We still have to bind `this` to the `TimecardsView`
    so that the `this` keyword finds the `timecards` collection.

2. Edit the constructor function and add another binding:

    ```javascriptblack
    constructor(props) {}
      super(props);
      ...
      this.sortByField = this.sortByField.bind(this);
    }
    ```

    Now we're ready to test. Test the application in the browser, switching field
    names in the sort `select` control. If the sort doesn't happen, check your
    console and debug.

## Wrap-up

To deal with form fields, we have to at least listen to:

* field changes, such as `onChange` in a `select` field
* submit events (not covered here) in `form` tags

We'll go deeper into forms in a later chapter, once we've defined a state storage
system with Redux.
