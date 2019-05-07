# Advanced Components: Exercises

We're going to use the `advanced-components` project for these exercises.

## Exercise Advanced Components #1 Set State

_Note: This exercise uses the root directory `src/01-set-state` in the `advanced-components` react application._

In this exercise, we'll experiment with `setState`. One of the exercises in the `Components` chapter mentioned the `setState` function takes an optional argument. We'll cover that argument here.

In this version of the application, the top-level `Blog` application determines whether the reduction button should be disabled. In previous versions, the `disabled` property of the reduction button was based on a JavaScript expression in the `ResizingButtons` component's `render` method. In this version, the `Blog` passes a new `prop` called `disableReduction`, and the sensitivity of the reduction button is based on the `this.props.disableReduction` value.

Here is `reductionRequestHandler` with the new code that sets the `disableReduction` value:

```jsx
reductionRequestHandler(size) {
 let reduceSize = size - 10;
 this.setState({size: reducedSize});
 this.disableReduction = reducedSize <= 10;
}
```

1. Hit the reduction button a few times to confirm that the reduction button becomes insensitive (turns red) the next time you press it after its label becomes `"Reduce to 10px"`.

2. As it turns out React _schedules_ an update when `setState` is called; the actual state change happens asynchronously. In this step, you see what happens if you code as if `state` is be updated synchronously. Change the `reductionRequestHandler` to set `this.disableReduction` based on `this.state.size` directly following the call to `this.setState` as follows. It might seem appealing to do so as an alternative to using `reducedSize` three times in as many lines:

    ```
    this.disableReduction = this.state.size <= 10;
    ```

    Now when you run the application, you will see that the reduction button does not become desensitized after the font size is reduced to 10px, and the application allows you to set the font size to 0px.

    If you add `console.log(this.state.size)` to `reductionRequestHandler` directly following the call to `setState`, you will see that `this.state.size` will always be one update behind. It will always be 10 greater than the `requested`reducedSize`. Naturally testing `this.state.size` to see if it less than or equal to 10 will not yield the expected result if the value of `this.state.size` if `state` is not in sync with the latest `state` change request.

    You can assume that `state` is current when `render` is called. It's fine to set `props` based on `state` in that method. We have been relying on `state` to be accurate in `render` through many of these exercises.

    However, you can't assume `state` is current in most user-defined methods.

3. Because `setState` only queues the update, React supports an optional callback parameter -- a function that it calls after the update actually fires.

    Try removing the line of code that sets `this.disableReduction` and replace the `setState` call with the following version that takes advantage of the optional callback parameter to set `this.disableReduction` after `state` has been updated. The `forceUpdate` call is necessary because the anonymous function does not modify anything other than an instance variable, behavior that does not normally trigger a DOM update.
Note that `forceUpdate` does not force a `state` update; rather it forces a DOM refresh.

    ```jsx
    this.setState({size: newSize - 10},
                  () => { this.disableReduction = this.state.size <= 10;
                          this.forceUpdate();
                        }
    );
    ```

Confirm that the application no longer allows you to set the font size to 0px.


## Exercise Advanced Components #2 `PureComponent`

_Note: This exercise uses the root directory `src/02-pure-component` in the `advanced-components` react application._

This exercise will give you a feel for when React re-renders by default and cover some techniques for overriding that default behavior.

This exercise uses a modified version of the blog application.

There are debug statements in the _render_ methods for the `ThemeButton` components and the `ResizingButtons` component so you will be able to see when React invokes _render_ for those components.

The `ThemeButton` component and the `ResizingButtons` component have also been modified so that they grow and shrink along with the blog post when the user adjusts the font size with the `ResizingButtons`. This was accomplished by passing them `size` as a `prop` and modifying the `style` object for each widget to set `fontSize` based on the `size` `prop`.

1. In this step you will see that React calls `render` for each of these components in each event cycle whenever there is any change to `state`, regardless of whether that particular component uses that piece of `state`.

    Run the application with the console open, and try pressing the theme buttons and resize buttons.

    You will see that `render` is called for each of these components whenever any button is pressed.

    In particular, notice that the `render` method for the resizing buttons is called when the theme changes -- even though these buttons do not listen for theme changes.

    When `state` changes, React calls the lifecycle method `shouldComponentUpdate` on each component to determine whether to invoke the component's `render` method. The default implementation of `Component#shouldComponentUpdate` returns `true`.

2. In this step we will ensure that `render` is only called for the resizing buttons when the user triggers a font size adjustment by extending `PureComponent` instead of `Component`.

    In `resizing-button-component` replace `Component` with `PureComponent` in the `import` statement and the `class` definition.

    ```jsx
    import React, {Pure Component} from 'react';
    ...
    class ThemeButton extends PureComponent {
    ```

    Now when you try the resize and theme buttons, you will see that React only invokes `render` on the resize buttons when the application-wide font size changes, but not when there is a theme change event.

The default implementation of `shouldComponentUpdate` for `PureComponent` does a _shallow_ comparison of the old `state` and `props` instance property values with the new `state` and `props` instance property values to determine whether `render` should be invoked. Its signature:

````jsx
shouldComponentUpdate(nextProps, nextState)
```
A _shallow_ comparison will only detect a difference when a primitive value changes or when a complex data structure was replaced wholesale.We will experiment with modifying a data structure in place in the next exercise.

It makes sense for the `Resizing` component to extend `PureComponent` because its props are all primitives, and because given the same `props` and `state`, it always renders the exact same way. It is not connected to any external data source or depend on external factors, and it does not use any kind of random data generator.

As an alternative to extending `PureComponent` you can provide your own custom implementation of `shouldComponentUpdate` for a particular component that only evaluates particular `props` or combinations of `props` or that applies a different kind of test.

Note that overriding the default `Component#shouldComponentUpdate` implementation, either by extending `PureComponent` or using your own implementation, is not always a good idea from a performance optimization standpoint. Remember that a call to `render` does not necessarily mean that an actual DOM update will inevitably follow. React is optimized to only update DOM nodes that have changed since the last time it checked, based on its analysis of the _React element_ returned from `render`. Comparing _React element_ properties, referred to as _virtual DOM_, is more efficient than analyzing the actual DOM. The call to `render`, which returns a lightweight object, can be considerably more efficient than a `shouldComponentUpdate` implementation.

Also, a custom implementation of `shouldComponentUpdate` can introduce subtle bugs and add maintenance overhead.

When deciding whether to use `PureComponent`, keep in mind that if `shouldComponentUpdate` returns `false` for a particular component, React will assume that none of its children should be updated and will not inspect them. Only extend `PureComponent` if any children always behave the same way given the same `props` and `state`.

## Exercise Advanced Components #3 `Shallow Compare`

_Note: This exercise uses the root directory `src/03-pure-component` in the `advanced-components` react application._

In this exercise, we'll further experiment with the `shouldComponentUpdate` implementation in `PureComponent`.

In the version of the application in the `03-pure-component` tree, `this.state.size` is not passed from the `Blog` component to its children. Instead a derived `sizeConfig` object passed down as the `sizeConfig` `prop`.

Here is how the `sizeConfig` object is initialized in the `Blog` component constructor:

```jsx
this.sizeConfig = {
  textSize: 20,
  headlineSize: 50,
  disableReduction: false
};
```

This snippet shows how `sizeConfig` is passed to the `ResizingButtons` component. A similar change was made for all of the `Blog` component children. The `disableReduction` value is now also packaged as part of this `sizeConfig` object, and the `ResizingButton`s component sets the sensitivity of the reduction button based on `this.props.sizeConfig.disableReduction`.

```jsx
 <ResizingButtons sizeConfig={this.sizeConfig} sizeChangeHandler={this.sizeChangeHandler}/>
```

Where `size` was used in previous versions, `sizeConfig.textSize` is used here. In previous versions, the `BlogPost` component set its headline font size in its `render` method by adding 30 to the value of the `size` `prop` that it received. In this version the `BlogPost` uses `this.props.sizeConfig.headlineSize`.

The size change handlers now call a new method, `updateSizeConfig`, to calculate the new headline size, determine if the reduction button should be disabled -- and update the `sizeConfig` object with the new `textSize`, `headlineSize` and `disableReduction` values.

```jsx
updateSizeConfig(newTextSize, configObject) {
  configObject.textSize = newTextSize;
  configObject.headlineSize = newTextSize + 30;
  configObject.disableReduction = newTextSize <= 10;
  return configObject;
}
```

Here is how the `enlargementRequestHandler` is implemented to ensure that the local `sizeConfig` object stays in sync with the application `state`. The `reductionRequestHandler` is similarly modified.

```jsx
enlargementRequestHandler(size) {
  let enlargedSize = size + 10;
  this.setState({size: enlargedSize});
  this.sizeConfig = this.updateSizeConfig(enlargedSize, this.sizeConfig);
}

```

There is nothing wrong with setting child `props` with a value or values derived or calculated based on state. We will talk more about derived values when we get into `redux`. In the version of this application we will use for one of the `redux` exercise, the theme colors will be derived in the `Blog` component instead of the `ThemeBar` component.

However, as you will see, there is a show-stopping problem with this code.

One other note before you try out this version in your browser. This version picks up where the last version we worked with left off. The `ResizingButtons` component extends `PureComponent`.

1. Try the theme buttons and the resizing buttons. The theme buttons work fine. But resizing buttons font size does not stay in sync with the `BlogPost` font size or the theme buttons font size. Additionally, the resizing button labels do not change to reflect the current font size.

2. In this step we will fix the problem. The issue is that the `updateSizeConfig` method modifies the `configObject` passed to it in place, and the code in the `enlargementRequestHandler` is passing it the `sizeConfig` object.

    The `ResizingButtons` component does not recognize that the `sizeConfig` object has been modified because it extends `PureComponent`, which does a _shallow_ comparison.

    Modify `enlargementRequestHandler` to create a `sizeConfig` object to pass to the `updateSizeConfig` method. You can use the spread operator as follows:

    ```jsx
    this.sizeConfig = this.updateSizeConfig(enlargedSize, {...this.sizeConfig});
    ```

    Now the `ResizingButtons` component's font size should stay in sync with the rest of the application.

One way to ensure that you won't run into this kind of problem is to use a library that enforces immutability by providing data structures that cannot be modified in place, such as `immutable.js`.









