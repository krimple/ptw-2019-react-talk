---
title: Advanced Components - labs
header-includes:
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[CO,CE]{\thepage}
    - \fancyfoot[LO,RE]{Chariot Solutions, 2016}
    - \fancyfoot[LE,RO]{React and Friends, v1.0 12/2/2016}
---
# Advanced Components Labs

## Advanced Components Lab #1 

This is a short lab to show you the asynchronous nature of setting state in a
component.

React allows you to call setState to modify the state of a component, say at
a lifecycle moment such as `componentDidMount` or during the processing of
an event.

## Background - the sometimes asynchronous nature of setting state
Quickly coding a state setting method, you might be tempted to do this:

```jsx
componentDidMount() {
  this.setState({
    foo: 'bar'
  });
  // unwise
  this.doSomething(this.state.foo);
}
```

In some cases, the code will work just fine - React will complete the state setting
synchronously for you.  But not in all cases.  That is why you have a second parameter,
the callback to execute when the state is finally set.

```jsx
// better
componentDidMount() {
  this.setState({
    foo: bar,
  }, () => { this.doSomething(this.state.foo); });
}
```

So, for safety's sake, don't assume that the `setState` method is always executed
synchronously. Use the callback method if you are chaining a step after initializing
data, especially when that data is fed from a promise resolution (such as when doing)
an Ajax call.

### Steps

1.  Open up your `timecards` project and modify the `TimeCardsView` component,
    setting it up to run asynchronously using `setTimeout`:

    ```jsx
    componentDidMount() {
     setTimeout(() => {
         this.setState({
             timecards: [
              ...
            ]
          },
          () => {
            console.log('Timecards: ${JSON.stringify(this.state.timecards)}');
          }
        );
      }, 1500);
    }
    ```

2. Re-run your application with the JavaScript console open, and see that the
   timecards are printed in the `setState` completed callback.

## Wrap-up

The component lifecycle can be tricky; React sequences updates of UI components
behind the scenes and batches them up for performance gains, and so what you think
should logically be a synchronous call ends up being asynchronous behind the scenes.


Check out the article from [thereignn.ghost.io/on-the-async-nature-of-setstate-in-react](http://thereignn.ghost.io/on-the-async-nature-of-setstate-in-react/)
and his sample github repository where he finds ways to make React's `setState` method
perform asynchronously if you want to see the edge cases in action.
