---
title: Components - labs
header-includes:
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[CO,CE]{\thepage}
    - \fancyfoot[LO,RE]{Chariot Solutions, 2016}
    - \fancyfoot[LE,RO]{React and Friends, v1.0 12/2/2016}
---
## Component Lab #1 - A Static Timecards application

In this lab, we'll create the shell of the Timecards application using `create-react-app`, a utility that builds a webpack-based development platform.

### Lab Steps

1.  Open a command prompt and switch to the `lab` directory of your setup.  Execute the following command:

    ```bash
    create-react-app timecards
    ```

     The project directory will be created, and the dependencies for the project will be configured. Now, switch to the `timecards` directory in your command line, and open up an editor of choice, pointing to the `labs\timecards` directory.

     We'll build a static mockup of a simple user interface. 

2.   Edit `App.js` in the `src` directory, and replace with:

    ```react
    import React, { Component } from 'react';
    import './App.css';

    class App extends Component {
      render() {
         return (
           <div>
             Timecards
           </div>
         );
      }
    }

    export default App;
    ```

2.  Start your web server with the command line, using `npm start`.  It should respond 
    after a moment that the web server is available on port 3000.  Open a browser and 
    browse to `http://localhost:3000`.

    The user interface is a stunning logo, with the body of the document containing a simple `Timecards` text block.  Clearly, we're ready for production.

    Now we'll start building up our mockup. We'll start by installing Twitter Bootstrap, so we can have a decent look and feel. 

2.  Open another command line and cd to the `lab/timecards` directory again. This time 
    we'll use the command line to install the dependency:

    ```bash
    npm install --save bootstrap
    ```

    Now that Bootstrap is installed as a `node_modules` depenency, we have to tell React about it. 

2.  Edit `src/index.js` and add the following line (as shown below):

    ```javascriptblack
    import React from 'React';
    ...
    import '../node_modules/bootstrap/dist/css/bootstrap.css';  <-- add this
    import './index.css';
    ```

    To complete our installation of Bootstrap, we need to make our outer `<div>` a bootstrap container. 

2.  Edit `public/index.html` and modify the `<div>` just below the `<body>` tag, adding 
    the `class="container" property:

    ```html
    <div id="root" class="container"></div>
    ```

    Now, we should be loading Twitter Bootstrap, and configuring the outer `<div>` as a Bootstrap container. 

2.  Refresh your page in your browser, and check your browser's development tools (e.g. 
    Chrome Developer Tools) to make sure the stylesheet is being loaded.

    In this application, we'll have a file and directory layout as shown:

    ```text
    timecards/
        public/           <-- The directory for all static files
          index.html      <-- The top-level HTML file for the app
        src/
          timecards/      <-- the individual timecard app components
            TimecardsView.js
            TimecardsTable.js
            ...
          App.js          <-- the top-level component
          App.css         <-- CSS style file for the Application
          Header.js       <-- the top-level header for the entire page
          index.css       <-- page-level CSS instructions
          index.js        <-- bootstraps the App component on the page
    ```

    In each step, we'll ask you to create files in a particular directory.
    Pay close attention to the directory we've requested. You may review
    the solution at `lab/timecards/component-solution` if you want to check
    your work or have to skip this lab during the course.

2. Now, let's create our application header, `Header.js` in the `src`
   directory. Add the following definition:

    ```jsx
    import Rect, {Component} from 'react';

    class Header extends Component {
      render() {
        return (
          <div className="navbar navbar-inverse">
            <h1 className="text-right" style={{ color: 'white' }}>
              Time Cards in React!
            </h1>
          </div>
        );
      }
    }
    ```

    The `Header` component can be mounted in the `render()`
    method of the `App` component, so let's do that. 

2.  Edit the `App.js` file in `src`. Import the class from the `Header.js`
    module and add the `<Header />` component to the `render()`
    method:

    ```jsx
    import Header from './Header';       <-- new
    ...

    class App extends Component {
      render() {
        return (
          <div>
            <Header />                   <-- new
          </div>
        );
      }
    }
    ```

2.  Make sure your app is running (execute `npm start` in the
    `timecards` project directory.

    Review your browser and you should see a nice header, properly styled, courtesy Bootstrap.

#### Building out the prototype - the Timecards section

Next, we'll build out our actual application component tree.

It is comprised of several nested components. They are:

* `TimecardsView`:  The top-level component that holds the
  state, namely the timecards collection.
* `TimecardsViewHeader`: The component that provides summary-level
  information about a table of timecards, such as the count.
* `TimecardsTable`: A component that renders a table structure
  to display the data rows.  The rows themselves are _not_
  ultimately part of this component.
* `TimecardsTableRow`: A component rendered for each table row
  that represents the visual view of a timecard.

With this in mind, let's set the components up, from the bottom
to the top of the hierarchy. We'll start with the `TimecardsTableRow`
component.

1.  Create `TimecardsTableRow.js` in the `src/timecards` directory.
    Fill it with the following definition:

    ```javascriptblack
    import React, { Component } from 'react';

    export default class TimecardTableRow extends Component {
        render() {
            const timecard = this.props.timecard;
            return(
              <tr key={timecard.id}>
                <td>{ timecard.date.toDateString() }</td>
                <td>{ timecard.hours }</td>
                <td>{ timecard.description }</td>
                <td>{ timecard.billable ? 'Yes' : 'No' }</td>
                <td>{ timecard.project }</td>
                <td><button className="btn btn-sm btn-danger">Complete!</button></td>
              </tr>
            );
        }
    }
    ```

    As you can see, this component is entirely dependent on data
    coming in as read-only properties from its parent. We use a
    shorthand in the template by assigning the variable `timecard`
    to the incoming `props.timecard` in the component instance.

2.  Next, let's fill in the `TimecardsTable`  component, which
    renders the table itself. Edit `TimecardsTable.js` in `src/timecards`
    and fill with the following:

    ```javascriptblack
    import React, { Component } from 'react';
    import TimecardTableRow from './TimecardTableRow';

    export default class TimecardsTable extends Component {

      render() {
        let rows = this.props.timecards.map((timecard) => {
            return <TimecardTableRow key={timecard.id} timecard={timecard}/>;
        });

        return(<table className="table table-bordered table-striped table-hover">
            <thead>
            <tr>
                <th>Date</th>
                <th>Hours</th>
                <th>Description</th>
                <th>Billable?</th>
                <th>Project</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            {rows}
            </tbody>
        </table>);
      }
    }
    ```

    Notice that the entire set of rows in the timecards table is
    rendered with a single expression, `{rows}`. The expression
    represents the collection of _React components_ defined above
    the return statement. It may feel odd to you that we are building
    an array of `<TimecardTableRow>` elements, rather than a set of
    value objects that are then rendered within another component.

    This is the way React works. JSX requires that all variables in
    expressions of the render method evaluate as HTML elements,
    components or lists of components. It will take a bit of getting
    used to, but soon you realize you have a lot of expressive power
    in the way you render your components.

    Our Timecards table needs an associated area to display information,
    such as the number of timecards available. We'll build this as another
    component.

2.  Create `TimecardsViewHeader.js` in `src/timecards`. Fill in the
    definition as follows:

    ```javascriptblack
    import React, { Component } from 'react';

    export default class TimecardsViewHeader extends Component {
        render() {
            return (<div className="row">
                <div className="col-xs-3">{ this.props.numRows } timecards</div>
            </div>);
        }

    }
    ```

    This component will get a variable, `numRows`, from the same
    place that the `TimecardsTable` gets its `timecards` variable from.
    We're going to build that outer component now, `TimecardsView`.

2.  Create a `TimecardsView.js` file in `src/timecards`. This component
    will hold our `timecards` collection, and so it is stateful.
    It mounts and feeds the `TimecardsTable` and `TimecardsViewHeader`
    components with their properties.

    Fill in the file with the following definition:

    ```javascriptblack
    import React, { Component } from 'react';
    import TimecardsViewHeader from './TimecardsViewHeader';
    import TimecardsTable from './TimecardsTable';

    export default class TimecardsView extends Component {
      componentDidMount() {
        this.setState({
            timecards:
              {
                id: 1,
                date: new Date(),
                hours: 5,
                description: 'Write lab book',
                billable: false,
                project: 'React Training',
                complete: false
              },
              {
                id: 2,
                date: new Date(),
                hours: 7,
                description: 'Review lab book',
                billable: false,
                project: 'React Training',
                complete: false
              },
              {
                id: 3,
                date: new Date(),
                hours: 2,
                description: 'Write Calendar App',
                billable: true,
                project: 'ABC Client',
                complete: false
              }
            ]
          });
        }

        render() {
          if (this.state && this.state.timecards) {
            return (
                <div className="container">
                    <TimecardsViewHeader
                      numRows={this.state.timecards.length}/>

                    <TimecardsTable
                      timecards={this.state.timecards}/>
               </div>
            );
          } else {
            return <div>Please wait...</div>;
          }
        }
    }
    ```

2.  Verify that the application renders the proper data as shown
    in the figure below:

    ![Figure Components-1 - The Timecards UI](images/components-lab/static-layout.png)

    ### Review

    Notice that this is just a mockup. Though the components
    are completely defined visually, they lack any technical
    features beyond rendering static data.

    One interesting area of this component is the way it loads
    and renders data. In a real application, the data may load
    asynchronously from an external source, potentially via a
    promise-based Ajax library. In this case, we will not have
    a `timecards` collection in state (and maybe not even a
    state collection) until the `componentDidMount` method
    completes.  In our render method, we check whether we have
    a valid state object in our component, and if so, whether
    it contains a timecards collection. If so, we render the
    child components, the `TimecardsViewHeader` and the
    `TimecardsTable`. They are passed the properties (`props`)
    of the `numRows` count and `timecards` collection respectively.

    In our next lab exercise, we'll focus on adding an event
    to our table row button, `Complete`, and on sorting the collection
    of timecards.

## Component Lab #2: events for sorting, completing timecards

In this lab, you'll see how to define events in your
components. The event in question will set the state of a
timecard so that it is marked as `complete`. Once the row is
marked complete, the button that allows it to be marked that
way is disabled, so that it cannot be selected again. We will
also add a sorting mechanism to the collection of timecards.

#### Containers - components that hold state

We're using a design pattern here in React - that of providing
state in a container component (`TimecardsView`) and presentation
/ display code in two components (`TimecardsTable` and `TimecardsViewHeader`).

The Single Responsibility Principal states that you should have one major
responsibility per object / component. In this case, the jobs of each
component are:

* `TimecardsView`: provide state for timecards, expose methods to manipulate state
* `TimecardsViewHeader`: allow changing of state at a macro-level
  (sorting, filtering), and report on information at a summary level
* `TimecardsTable`: render the table of timecards
* `TimecardsTableRow`: Render each table row, allow manipulation of state in `TimecardsView`

So we've pretty much sussed out the responsibilities of each component. Now we
have two features to add:

* Sorting a collection of timecards
* Marking a timecard as complete

Where is the best place for each of these features to a) be exposed and b) be executed?

The execution is easy - since the `TimecardsView` component _owns_ the Timecards as state,
it's the job of that component to hold the state and thereby expose methods to maniuplate it.

For marking a timecard complete, the best place to do that is at the row level - so we've
already placed a button there in anticipation of wiring up this feature. That means
somehow we have to execute a method in `TimecardsView` from a `TimecardTableRow` instance.

We'll use `props` to solve this problem.

#### Adding an event - completing a timecard.

1.  First, let's add the method to complete a timecard to the `TimecardsView` component.
Edit `src/timecards/TimecardsView.js` and add the following method in the class
body:

    ```javascriptblack
    completeTimecard(key) {
        this.setState({
          timecards: this.state.timecards.map((timecard) => {
            if (key === timecard.id) {
              timecard.complete = true;
            }
            return timecard;
          })
        });
      }
    ````

    Now we have a method we can expose and provide to our inner components. The 
    best place to do that is as a `prop`.

2.  Now modify the `render()` method of `TimecardsView`, passing in the 
   `completeTimecard` property that points to our method:

    ```javascriptblack
    render() {
      ...
      return (
         <div className="container">
           <TimecardsViewHeader numRows={this.state.timecards.length}/>
           <TimecardsTable timecards={this.state.timecards}
                           completeTimecard={this.completeTimecard} />  <-- new
         </div>
      );
    ```

#### Binding `this` in function calls

Next, we have to make sure that JavaScript properly binds the `this` context
variable to the `TimecardsView` when another component triggers the referenced
action.  The prevailing technique is to let the constructor of the object `bind`
the `this` keyword for us.

It seems odd that you have to do that work. But it turns out that the `this`
keyword in Java is bound at runtime, and can change depending on the way it is
being called.

In the case of methods passed from one component to another via `props`, the
`this` keyword will generally be `window` if they are fired from an event
such as a `click`, or an event if fired by a `timer`, and so on. So let's play it safe.

1.  We'll create a constructor function for the `TimecardsView`
    component. Put it near the top of the class definition so it can be easily found:

    ```javascriptblack
    constructor(props) {
      super(props);
      this.completeTimecard = this.completeTimecard.bind(this);
    }
    ```

    Now any inner component passed the `completeTimecard` function as a prop will get a
    reference to a function, using JavaScript's `bind` function to bind the `this`
    keyword to the object that was being constructed at the time, `TimecardsView`.

    Also, notice we recieve a `props` parameter when our component is constructed,
    and we call the `super`'s constructor (the one from `react.Component`).  This
    is _absolutely required_, as the base constructor is the one that propagates
    the properties from one to another. The super constructor _must_ be called
    first in JavaScript.

#### Passing methods through props

It turns out we have two more steps to complete here. First, we need to recieve
the `completeComponent` method in our `TimecardsTable` component, then send it
along to a child component, `TimecardsTableRow`, so that each row can complete
itself.

1.  First, edit the `TimecardsTable` component and modify the beginning of the
    `render()` method to look like this:

    ```javascriptblack
    let rows = this.props.timecards.map((timecard) => {
      return (
        <TimecardTableRow
          key={timecard.id}
          timecard={timecard}
          completeTimecard={this.props.completeTimecard} />;   <-- new
      );
    });
    ```

    Now we need a local method on this component
    that can be called by a click event, and that can grab the ID of the timecard,
    passing it along to the `completeTimecard(id)` method in `props

2.  Edit the `TimecardsTableRow` and create our local event method, binding it
    to the `this` context of `TimecardsTableRow` in the constructor.

    ```javascriptblack
    constructor(props) {
      super(props);
      this.doCompleteTimecard = this.doCompleteTimecard.bind(this);
    }

    doCompleteTimecard() {
      this.props.completeTimecard(this.props.timecard.id);
      }
    ```

2.  Finally, modify the button in the `render()` method of `TimecardsTableRow` to
    look like this:

    ```javascriptblack
    render() {
            ...
            <button className="btn btn-sm btn-danger"
                    disabled={this.props.timecard.complete}       <-- new
                    onClick={this.doCompleteTimecard}>            <-- new
                Complete!
            </button></td>
            ...
    }
    ```

    This allows the individual `TimecardTableRow` to tell the `TimecardsView`
    component to complete the timecard. The instant the change is made in state,
    updated props flow downward to the `TimecardTable` and its changed rows, which
    will set the `disabled` property of the button to `true`, disallowing any additional
    changes.

2.  Try it!  Test your application in the browser again at `http://localhost:3000`. 
    You should be allowed to complete a time card exactly once. 

    Refresh the browser and load the state all over again if you run out of buttons to click.

    If you're not able to see the state change, make sure to open your browser console
    and take close note of the error messages that might be emitted. You can always
    debug the application - place a `debugger` statement in your code and refresh the
    browser with your developer tools pointed to the source code. It should stop on
    a breakpoint and allow you to debug.

### Wrap-up

In this lab we've seen how to create a static mockup of your component hierarchy, broken
into components for specific levels of your user interface. We configured one component, 
`TimecardsView`, to hold the state of the timecards.  We then fed the data downward
view headers, a table, and table rows to place data in the correct places.

Next, we added a function to mutate the state in the `TimecardsView` component, 
which set the `complete` flag to `true` on a given `timecard`.  Finally, we sent
that event down as a prop to the `TimecardTableRow` component (including it along
the way in the `TimecardsTable` component as wel), and used a local event binding
to call the completion method in the `TimecardsView` component when clicking the 
button on our row.
   