---
title: Components - Exercises
header-includes:
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[CO,CE]{\thepage}
    - \fancyfoot[LO,RE]{Chariot Solutions, 2016}
    - \fancyfoot[LE,RO]{React and Friends, v1.0 12/2/2016}
---

This series of exercises will not only give you practice with React syntax and semantics, it will give you insight into how React developers think about designing applications. These exercises are structured around the [Thinking in React](https://facebook.github.io/react/docs/thinking-in-react.html) section of the React documentation that was written by Pete Hunt, the React core developer who packaged the original React code his team developed at Facebook so that it could be open-sourced.

His article explains the rationale behind each design decision involved with building a filterable product table, but assumes that the reader knows how to create React components and bind them to events.

Pete distilled the process of "Thinking in React" into the following steps:

* Before Starting: Build a mock
* Step 1: Break the UI into a component hierarchy
* Step 2: Build a static version in React
* Step 3: Identify the minimal (but complete) representation of UI state
* Step 4: Identify where your state should live
* Step 5: Add inverse data flow

These exercises will walk you through the process of creating an application that displays a blog post. We will cycle through each of these steps, filling in the React basics along the way.

## Pre-requisite - change projects!

We're going to use the `components` project for these exercises. Open the `components` application from your labs directory in your favorite IDE.

```bash
cd <labs-dir>/components
npm install
npm start
```

When you save the changes you need to make in order to complete an exercise, your browser will automatically refresh. If all goes well, your changes will be reflected in the running application. Otherwise you will see errors in the console.

## Exercise Components #1 Build a Mock

Normally the first step would be to start with specs and then to sketch out a mock. In this case, we are going to do the polar opposite of that, and start by demoing the completed application because this is an exercise, and that is the most efficient way to show you where we're going with this exercise.

This application supports a limited subset of blog functionality. You can use it to view a blog post and customize the page. The body text color and size, the title color, and background color are configurable.

You select a palette by pressing one of the theme buttons. The blog body text will match the button label text, the blog background will match the theme button background color, and the blog title color will match the theme button border color.

The grey buttons enable the user to adjust the size of the text in 10 pixel increments. When the body text size is 10 pixels, the label on the "Enlarge" button reads "Enlarge to 30px" and the label on the "Reduce" button reads "Reduce to 10px". When the user changes the text size, the button labels stay in sync, with the "Enlarge" button specifying a size 10 pixels larger and the "Reduce" button displaying a size 10 pixels larger. When the font size gets down to 10px the "Reduce" button becomes insensitive, so the font size never gets smaller than 10px.

  ![Figure Components-1 - Blog Mock](images/components-exercises/blog_mockup.png)

## Exercise Components #2 Component Hierarchy

Here is an image of the screen in lieu of a mock to use for reference as you consider step 2 in the "Thinking in React" progression: Break the UI into a component hierarchy.

In "Thinking in React", Pete Hunt recommends first identifying components using the single responsibility principle, and then arranging them hierarchically.

We've identified five components and we have drawn a box around each one.

The five components and their responsibilities are:

_Blog_: serves as the top-level application container
_Theme Bar_: generates and serves as a container for the theme buttons
_Theme Button_: used to customize the blog palette
_Resizing Button Bar_: contains buttons used for adjusting the text size
_Blog Post_: displays the blog post and its title

"Thinking in React" suggests building the hierarchy based on the boxes drawn on the mock. Any component with a box inside of it should be the direct parent of the component inside the box.

Using that criteria, the application breaks down as follows:

```text
Blog
  ThemeBar
    ThemeButtons
  ResizingButtons
  BlogPost
```


![Figure Components-2 - Blog Hierarchy](images/components-exercises/blog_hierarchy.png)


## Exercise Components #3 Rendering with JavaScript

_Note: This exercise uses the root directory `src/03-js` in the `components` react application._

Components typically extend `React.Component` and are required to implement `render`. The `render` method must return a _React element_ and can either be written in JavaScript or JSX, an XML-like syntax developed by the React team.

The next several exercises cover the JavaScript API.

This exercise concerns creating _React elements_ using `React.createElement` and rendering React components using `ReactDOM.render`.

`React.createElement` generates a _React element_, which is an object with key/value pairs that describe the type and properties of a standard DOM element or a React component (which, at its core, is composed of standard DOM elements). React can render changes to the DOM efficiently because it determines how much needs to be re-rendering during a particular event cycle by comparing _React element_ properties as opposed to performing diffs on the DOM itself.

`ReactDOM.render` takes two arguments: 1) a _React element_ and 2) a standard DOM element that should serve as a host for the _React element_. It generates a DOM element based on the _React element_'s type and properties -- and it inserts that DOM element into the DOM element specified as it's second argument.

Note that both React and ReactNative share `React.createElement`. `ReactDOM.render` is used for generating DOM elements based on _React element_s, and ReactNative has a comparable API for server-side or mobile application rendering.

1. Look at the blog post scaffolding in your browser and open the following three files to look at the corresponding source code for the skeletal `BlogPost` component: `blog-post-component.js`, `index.js`, and `public/index.html`.

    The `BlogPost` component defined in `blog-post-component.js` meets the minimal requirements a React component must fulfill. It extends `Component` and implements the required `render` method, using `createElement` to return the required _React element_. It creates a _React element_ that describes a `div` with a single child node that contains the text: `Big Post Placeholder`.

    ```javascriptblack
    // from  blog-post-component.js
    class BlogPost extends Component {

      render() {
        return React.createElement(
          'div',
          {
            /* any properties, class names styles &
               event bindings
               would go here
            */
          },
          "Blog Post Placeholder"
        );
      }
    }
    ```

    As noted above, `React.createElement` can create either a _React element_ that describes a standard DOM element or a _React element_ that describes a React component. The first argument to `ReactDOM` in 'index.js' is a _React element_ that describes a `BlogPost` React component, and the second argument is DOM element that will serve as a host for that React component.

    ```javascriptblack
    // from  index.js
    ReactDOM.render(
      React.createElement(BlogPost),
      document.getElementById('blog-post')
    );
    ```

    In `index.html`, the `div` that serves as a host for the `BlogPost` React component is identified with the `id`, `blog-post`.

```htmlblack
    <html>
      <div id='blog-post'>
      </div>
   </html>
```

2. Add a placeholder for the blog post title by inserting `"Blog Title Placeholder"` prior to `"Blog Post Placeholder"` in the argument list for `createElement` in `blog-post-componnent.js`.  The last argument to `createElement`, which represents any children of the element, is a variable-length argument.

    ```javascriptblack
    React.createElement(
      'div',
      {},
      "Blog Title Placeholder",
      "Blog Post Placeholder"
    )
    ```

    Notice that the title placeholder and the blog post placeholder run into each other on the same line. Add a line break between them by using `createElement` to generate a _React element_ that represents a line break element.

    ```javascriptblack
      "Blog Title Placeholder",
      createElement('br'),
      "Blog Post Placeholder"
    ```

3. Create a `Blog` component that contains a `BlogPost` component, and display the new `Blog` component in the browser instead of the building block `BlogPost` component. Starting with the smaller, inner-most components, and solidifying them as you build up larger, composite components, as we are modeling here, and starting with a top-level component while stubbing out any children, are both good approaches.

    3a. Open the component template in `src/blog-component.js`, and replace the `Placeholder` class name with `Blog` in the class declaration and the export statement.

    ```javascriptblack
    // from blog-component.js
    class Blog extends Component {
    ...
    }
    export default Blog;
    ```

    3b. Replace the placeholder string representing a `BlogPost` _React element_ with an actual `BlogPost` _React element_. Note that `BlogPost` is not in quotes. Uses quotes when the first parameter to `createElement` represents the type of a standard DOM element, not when it represents a React component class.

    ```javascriptblack
    render(
      'div',
      {},
      createElement(BlogPost)
    );
    ```

    3c. Represent the theme bar with a couple of buttons, labelled `"Theme 1"` and `"Theme 2"`.

    ```javascriptblack
    render(
      'div',
      {},
      createElement('button',[],'Theme 1'),
      createElement('button',[],'Theme 2')
      createElement(BlogPost)
    );
    ```

    3d. Display the `Blog` component by passing `Blog` to `createElement` instead of `BlogPost` for the first argument to `ReactDOM.render` in `index.js`. You should see the `Blog` representation in your browser, including the theme bar placeholder as well as the blog post placeholder.

    ```javascriptblack
    // from  index.js
    ReactDOM.render(
      React.createElement(Blog),
      document.getElementById('blog-post')
    );
    ```

    3e.  As you have seen, it is not necessary to change the id for `Blog` component host from `"blog-post"` to `"blog"`, but descriptive labels are important, even in exercises, so change the `id` from the `div` that serves as the host for the `blog` in `public/index.html` to `"blog"`, change the `id` passed to `document.getElementById` in `index.js` to `"blog"`, and make sure the `Blog` component still shows up in your browser.

    This exercise was also included to call your attention to certain pieces of boilerplate code that are generated by `create-react-app` React application generator you will use to jump-start development of the time-card application you will build as a lab. That generator will generate a class called `App` that extends `Component` and a file in `public/index.html` with a `div` with the id `root` that will serve as the host for the `App` component. In the generated `index.js` file, the element that has `root` for an id is the second argument passed to `ReactDOM.render`. Any `id` will work.
`

    3f.  In this step, we'll experiment with the first argument to the `createElement` call that generates the _React element_ returned by the required `render` method in a class that extends `Component`.

    The first argument to `createElement` represents the _type_ of DOM element the _React element_ will describe. Any children, including `String`s, standard DOM elements or React components will be enclosed within that _type_ of element.

    3f1. Open the console so that you will see any `Error`s resulting from your changes.

    3f2. In `blog-component.js`, try changing the first argument to the first `createElement` call from a 'div' to a `button`.

    ```javascriptblack
    return React.createElement(
      'button',
      {},
      React.createElement('button',{},"Theme 1"),
      React.createElement('button',{},"Theme 2"),
      React.createElement(BlogPost)
    );
    ```
    As you can see, React has not raised an `Error`, but has stuffed all of the child _React element_s specified at the end of the argument list into a top-level `button`. While it's hard to imagine a scenario where it makes sense for a `button` to be the parent element for anything other than a label, React will not evaluate the list of child elements you specify for any type of element that supports content.

    3f3. Try replacing `button` with a void or empty element type, such as an horizontal rule (`hr`) or a hard return (`br`).

    ```javascriptblack
    return React.createElement(
      'br',
      {},
      React.createElement('button',{},"Theme 1"),
      React.createElement('button',{},"Theme 2"),
      React.createElement(BlogPost)
    );
    ```

    You should see an `Error` message in the console along the lines of "Uncaught Error: br is a void element tag and must neither have `children` nor use `dangerouslySetInnerHTML`." We will cover `dangerouslySetInnerHTML`, one of React's security features, in the next exercise. To eliminate the `Error` you would either need to revert back to a type that can serve as a valid parent, such as a `div` or `span`, or remove any child components. Recall that we passed `br` as the sole argument to `createElement` to put a carriage return between the `Title Placeholder` and the `Blog Post Placeholder` in the `BlogPost` component class.

    Replace the void element type with `div` and ensure that there are no errors in the console before moving on.

## Exercise Components #4 Properties and JavaScript

_Note: This exercise uses the root directory `src/04-js-properties` in the `components` react application._

The second argument to `createElement` is an object with keys that represent standard DOM element properties (i.e. styles and class names), SVG properties and custom properties. We will cover custom properties, referred to in React as `props`, in the next exercise.

In most cases, the property keys have the same names as the corresponding property names used in standard HTML tags, except that camelCase should be used for React where dashes are used in standard HTML tags -- and for the most part, the property keys are used the same way their standard HTML counterparts are used.

This exercise covers the ways that setting properties for a _React element_ mirror setting properties in an HTML tag and also covers differences between how React handles certain properties and how they are specified in HTML.


1. In `blog-component.js`, use the `title` property to add tooltips to the theme buttons and the `id` property to specify an `id` for each button.

    1a. Add the following key/value pairs to the empty objects serving as placeholders for properties that should be applied to the theme buttons: `{title: "Apply Theme 1 to the blog post.", id: "one" }` and `{title: "Apply Theme 2 to the blog post.", id: "two" }`.

    ```javascriptblack
    return React.createElement(
      'div',
      {},
      React.createElement('button',
                          {title: "Apply Theme 1 to the blog post", id: "one" },
                          "Theme 1"),
      React.createElement('button',
                          {title: "Apply Theme 2 to the blog post", id: "two"},
                          "Theme 2"),
      React.createElement(BlogPost)
    );
    ```

    1b. Confirm that the `title` property was applied. A tooltip should appear when you mouse over each theme button.

    1c. Confirm that the `id` property was applied using `document.getElementById`.

    In the console, enter `document.getElementById("one")`. You should see something like the following:

    ```javascriptblack
    <button title="Apply Theme 1 to the blog post" id="one">Theme 1</button>
    ```

2. There are two property names that are different in React than in HTML because they are reserved words in JavaScript: `for` and `class`. Use `htmlFor` and `className` in React.

    2a. Use `className` to differentiate the title from the blog post in `src/blog-post-component.js`.

    The `title` class properties are defined as follows in `src/index.css` :

    ```javascriptblack
    .title {
      font-weight: bold;
      font-size: 20px;
    }
    ```

    2b. In `blog-post-component`, replace the blog title and blog post placeholders with the following _React element_s so they can be styled.

    ```javascriptblack
    React.createElement('span',{},"Blog Title Placeholder"),
    React.createElement('br'),
    React.createElement('span',{},"Blog Post Placeholder")
    ```

    2c. Specify a class for the title element by adding the following key/value pair to the second argument to the `createElement` call for the title element. When you next look at your browser, the title text should be larger and bolder than the blog post text.

    ```javascriptblack
    React.createElement('span', {className: "title"}, "Blog Title Placeholder")
    ```

3. Use inline styles to set a background color to `yellow` for the whole blog post and different colors for the title text (`green`) and blog post text (`blue`). The property key name `style` is identical to the corresponding HTML property name, but the style value is an object in React, not a string.

    The following snippet shows the `render` method with styles specified for the whole blog post and the individual _React element_s that comprise the blog post. Note that camelCase is used for `backgroundColor`, which would be `background-color` in HTML.

    ```javascriptblack
    render() {
      return React.createElement(
        'div',
        { style: {backgroundColor: "yellow"} },
        React.createElement('span',
                            { style: {color: "green"}, className: "title" },
                            "Blog Title Placeholder"),
        React.createElement('br'),
        React.createElement('span',
                            { style: {color: "blue"} },
                            "Blog Post Placeholder")
      );
    }
    ```


4. To switch a boolean property _on_ for a _React elements_ using JavaScript, set it to `true`. In HTML, you can desensitize a button by adding either `disabled` inside its start brackets without assigning a value to it. In React's JavaScript API, you need to assign a value to the property key `disabled`.

    Hide the theme buttons (since they won't work until we wire them up to event handlers in a future step), by using the `hidden` property key word.

    4a. For `Theme Button 1`, assign the value `true` to hidden.

    4b. For `Theme Button 2`, create a variable called `underDevelopment`, set it to `true`, and bind it to the `hidden` key.

    Your `render` method should look something like this.

    ```javascriptblack
    render() {

      let underDevelopment = true;

      return React.createElement(
        'div',
        {},
        React.createElement('button',
                            { hidden: true,
                            title: "Apply Theme 1 to the blog post",
                            id: "one" },
                            "Theme 1"),
        React.createElement('button',
                            { hidden: underDevelopment,
                            title: "Apply Theme 2 to the blog post",
                            id: "two"},
                            "Theme 2"),
        React.createElement(BlogPost)
      );
    }
    ```

    Neither theme button should show up after you save and check your browser.


5. In order to ensure that developers think twice about using the `innerHTML` property and creating a potential opening for a
cross-site scripting attack, React provides an alternative.

    To generate a _React element_ that in turn generates DOM with an `innerHTML` value, you need to use the property key `dangerouslySetInnerHTML`, and instead of pairing that property key with a string, you need to pair it with an object with a single key/value pair. The key needs to be `__html` and the value should be a string. The string will not be escaped. In this step, you will see unescaped HTML in action, courtesy of `dangerouslySetInnerHTML`.

    5a. Use `dangerouslySetInnerHTML` to enlarge and override the color of the blog post text. Turn it red and set its font size to 100, by adding the `dangerouslySetInnerHTML` key/value pair shown below and removing the third argument to `createElement`, the string literal `"Blog Post Placeholder"`. Notice that `Blog Post Placeholder` is embedded in the string paired with the property key `dangerouslySetInnerHTML`.

    If you look at your browser after adding the `dangerouslySetInnerHTML` key/value pair, but before removing the third argument to `createElement`, you will see the an error message explaining that you can either specify content using `dangerouslysetInnerHTML` or the third argument to `createElement`, but not both.

    ```jsx
    React.createElement('span',
      { dangerouslySetInnerHTML: 
          {__html: "<span style='color:red;font-size:50px;'>" +
                                          "Blog Post Placeholder</span>"},
        style: {color: "blue"}})
    ```

    Once you have seen the oversized `BlogPost`, restore the `BlogPost` to its previous size and color to prime the file for the next exercise. Remove the `dangerouslySetInnerHTML` key/value pair, and add back the third argument to `createElement`, the string literal `"Blog Post Placeholder"` so that the `createElement` call looks like this:

    ```javascriptblack
    React.createElement('span',
                        {style: {color: "blue"}},
                        "Blog Post Placeholder")
    ```

## Exercise Components #5 `Props` and JavaScript

_Note: This exercise uses the root directory `src/04-05-js` in the `components` react application._

Custom properties are specified the same way that standard HTML properties are specified, using the custom property name as a key in the second argument to `createElement` -- however, custom properties are _not_ specified on a _React element_ the way standard HTML properties are specified. Rather, they are specified in a parent component and passed to a downstream child component for consumption.

Custom properties in React are referred to as `props`.

This exercise covers specifying `props` in a parent component and consuming them in a child component.

1. Use `props` to set the background color and text color for the blog post title and text. Call the custom properties `pageColor`, `blogPostColor`, and `headlineColor`.

    Add key/value `props` pairs to the `Blog` top-level parent component in `blog-component.js` to configure the child `BlogPost` component palette, using different colors than you used in the previous exercise, as follows:

    ```javascriptblack
      React.createElement(BlogPost, {pageColor: "lightGreen",
                                     blogPostColor: "purple",
                                     headlineColor: "orange"})
    ````

2. Consume the `props` values in the `createElement` calls in the child `BlogPost` component in `blog-post-component`. The `props` are exposed to the child component via `this.props`. Dot notation can be used to access each individual `prop` value. For example, `this.props.pageColor` yields `"lightGreen"`. When you are finished with this step, you should see the new color scheme in your browser.

    Instead of using string literals to configure the color palette for the `BlogPost` component, use `this.props`.

    2a. Replace `backgroundColor: "yellow"` with `backgroundColor: this.props.pageColor`.

    2b. Replace `color: "green"` with `color: this.props.headlineColor`.

    2c. Replace `color: "blue"` with `color: this.props.blogPostColor`.

3. Use ES6 destructuring to reduce clutter in your `render` method.

    You can access the `props` values without the `this.props` prefix when you extract the individual props values as follows:

    ```javascriptblack
    const {pageColor, blogPostColor, headlineColor} = this.props;
    ```

    Using ES6 restructuring, `render` for the `BlogPost` component should look like the following:

    ```javascriptblack
    render() {
      let {pageColor, blogPostColor, headlineColor} = this.props;
      return React.createElement(
        'div',
        { style: {backgroundColor: pageColor} },
        React.createElement('span',
                            {style: {color: headlineColor}, className: "title"},
                            "Blog Title Placeholder"),
        React.createElement('br'),
        React.createElement('span',
                            {style: {color: blogPostColor}},
                            "Blog Post Placeholder")
      );
    }
    ```

4. Default values for `props` can be specified in the same file as the component that consumes them.

    Configure a default color palette for the `BlogPost` by assigning key/value pairs to `BlogPost.defaultProps`. Paste the following into `blog-post-component.js` beneath the class definition.

    ```javascriptblack
    BlogPost.defaultProps = {
      pageColor: 'gray',
      blogPostColor: 'gold',
      headlineColor: 'maroon'
    };
    ```

    There should be no change when you look at your browser because the values specified in the parent component override the default values. Try removing the `blogPostColor` and `headlineColor` from the second argument to the `createElement` call that generates the `BlogPost` in the parent `Blog` component in `src/blog-component.js`. React should now use the default `blogPostColor` and `headlineColor` values: `'gold'` and `'maroon'`.


## Exercise Components #6 Rendering with JSX

_Note: This exercise uses the root directory `src/06-jsx` in the `components` react application._

JSX is a DSL that enables you to render components using HTML-like syntax.

Although it looks like HTML, JSX actually generates JavaScript, not HTML.

In JSX, inserting a standard HTML type name or React component class name between angle bracket to form HTML-like start and end tags generates a call to `createElement` with the specified HTML type name or React component class Name passed in as the first argument.

Child elements in JSX are positioned between the start and end tags.

Where any properties are expressed as key/value pairs in the properties object passed to `createElement in JavaScript -- properties are specified using standard HTML syntax within the start tag angle brackets in JSX, using the assignment operator (`=`) to link property names with their values. Property values can either be string literals or JavaScript expressions in JSX.

In other words, the following JSX...

```jsx
<button title="Apply Theme 1 to the blog post">
  Theme 1
</button>
```

...generates the following JavaScript:

```javascriptblack
React.createElement('button',
                    {title: "Apply Theme 1 to the blog post"},
                    "Theme 1");
```

Since JSX generates JavaScript, you can embed JSX into JavaScript code, and you can embed JavaScript expressions into JSX as property or `prop` values.

To use JavaScript expressions as property values, enclose them in curly braces, for example: `hidden={underDevelopment}`.

In this exercise, convert parts of the `render` methods in the `Blog` and `BlogPost` component classes from JavaScript to JSX.  Along the way we'll walk through some of the ways you can mix and match JSX and JavaScript, and we'll also look at the few properties that require special handling in JSX (boolean properties and `style`).

1. Replace the `createElement` call that generates the theme buttons in `blog-component.js` with the equivalent JSX so that the return statement in the `render` method looks like the following:

    ```jsx
    render () {

      const underDevelopment = true;

      return React.createElement(
        'div', {},
        <button hidden
                title="Apply Theme 1 to the blog post"
                id="one">
          Theme 1
        </button>,
        <button hidden={underDevelopment}
                title="Apply Theme 2 to the blog post"
                id="two">
          Theme 1
        </button>,
        React.createElement(BlogPost, {
                              pageColor: "lightGreen",
                              blogPostColor: "purple",
                              headlineColor: "orange"
                            })
      );

    }
    ```

    Notice that there are no quotes or back tics around the JSX code, and that it's possible to embed JSX right in the middle of `createElement`'s argument list.

    Also notice that for the "Theme 1" button, the `hidden` property key is not assigned a value. In JSX, boolean properties will be interpreted as `true` if you place the property name within the start tag angle brackets.

    You will see an `Error` in the console if you try to specifying that an element should be `hidden` using `hidden=true`. However, the expression `hidden={true}`, is valid, as is `hidden={underDevelopment}`, where `underDevelopment` is a variable name, modeled for the "Theme 2" button.


2. Styles in JSX are specified between two sets of curly braces: `style={{ color: "blue", backgroundColor: "red"}}`. The outer set of curly braces is needed because the `style` value is a JavaScript expression -- an object. The inner curly braces are needed for the object syntax. Styles are specified using key/value pairs in both JavaScript and JSX. But JSX uses the assignment operator to link the property name `style` with the `style` object, and in the JavaScript, the property name `style` is paired with the `style` object using a colon (`style: { color: "blue", backgroundColor: "red"}`).

    Style the theme buttons using JSX.

    2a. Remove the `hidden` property from both buttons.

    2b. Use JSX create a container `div` for both theme button so that you can apply common styles to both buttons:

    ```jsx
    return React.createElement(
      'div',
      {},
      <div>
        <button title="Apply Theme 1 to the blog post" id="one">
         Theme 1
        </button>
        <button  title="Apply Theme 2 to the blog post" id="two">
          Theme 2
        </button>
      </div>,
      React.createElement(BlogPost, {
                            pageColor: "lightGreen",
                            blogPostColor: "purple",
                            headlineColor: "orange"
                          })
    );
    ```

    2c. Give the new `div` a bottom margin of 10 pixels using `style={{marginBottom: "10px"}}`.

    2d. Give the "Theme 1" button a blue 5 pixel border and blue text using `style={{borderWidth: "5px", borderColor: "blue", color: "blue"}}`

    2e. Give the "Theme 1" button a green 5 pixel border and green text using `style={{borderWidth: "5px", borderColor: "green", color: "green"}}`

    The return clause should now look like the following snippet:

    ```jsx
    return React.createElement(
      'div',
      {},
      <div>
        <button title="Apply Theme 1 to the blog post" id="one"
                style={{
	                     borderWidth: "5px",
	                     borderColor: "blue",
	                     color: "blue"
	                   }}>
         Theme 1
        </button>
        <button  title="Apply Theme 2 to the blog post" id="two"
                 style={{
	                      borderWidth: "5px",
	                      borderColor: "green",
	                      color: "green"}}>
          Theme 2
        </button>
      </div>,
      React.createElement(BlogPost, {
                            pageColor: "lightGreen",
                            blogPostColor: "purple",
                            headlineColor: "orange"
                          })
      );
    ```

3. In this step, we'll use conditional logic within the JSX code to underline the currently chosen theme. For this exercise, we'll contrive a "current theme" using a variable. The theme buttons won't be operational for a few more exercises.

    3a. Paste the following variable assignment under the `underDevelopment`:

    ```javascriptblack
    let theme = "blue";
    ```

    3b. Use the newly added `theme` variable to set the background color for the blog by replacing the value paired currently paired with the `pageColor` property key (`"lightGreen"`) with `theme`. The background behind both the blog title and the blog post should now be blue.

    3c. Use a ternary expression to set the `textDecoration` css property value to `"underline"` if the theme matches the theme button text and border color. The ternary expression can be placed directly in the `style` object. Since the `style` object is already flanked with curly braces, marking it as a JavaScript expression, there is no need to add additional curly braces for the ternary expression.

    3c1. Add the following key/value pair to to the `style` object for the "Theme 1" button:

    ```jsx
    textDecoration: theme === "blue" ? "underline" : "none"
    ```

    3c2. Add the following key/value pair to the `style` object for the "Theme 2" button:

    ```jsx
    textDecoration: theme === "green" ? "underline" : "none"
    ```

    3d. Change the value of theme from `"blue"` to `"green"`. The label on the "Theme 2" button should now be underlined, and the background color for the blog should now be green.

4. In this step, we'll hide the buttons again, but we'll embed JSX tags within conditional logic to accomplish this instead of using the `hidden` property. We'll use a stripped-down version of the `Blog` component because the behavior will be observing will be easier to follow if there are fewer lines of code to manipulate.

    For this step, it's important to know that React will not render an expression that evaluates to null or false in JSX. One way to conditionally display particular elements is to create a compound boolean expression including an conditional expression and the element using the logical AND operator (&&).

    For example, based on the following JSX code (and assuming `productionReady` is a variable), the `BlogPost` component will only be rendered, when `productionReady` is `true`:

    ```javascriptblack
    { productionReady && <BlogPost/>}
    ```

    4a. Replace the class definition for the `Blog` component with the following:

    ```jsx
    class Blog extends Component {
      render() {
        return (
          let productionReady = false;
          <div>
            <div style={{marginBottom: "10px"}}>
              <button>
                Theme 1
              </button>
              <button>
                Theme 2
              </button>
            </div>
            <BlogPost/>
          </div>
        )
      }
    }
    ```

    4b. Conditionally display the `div` containing the theme buttons using the `productionReady` variable and the `&&` operator as follows. Confirm that the buttons do not show up. Confirm that the buttons appear when you set `productionReady` to `true`.

    ```jsx
    class Blog extends Component {
      render() {
        let productionReady = false;
        return (
          <div>
           { productionReady &&
            <div style={{marginBottom: "10px"}}>
              <button>
                Theme 1
              </button>
              <button>
                Theme 2
              </button>
            </div>
           }
            <BlogPost/>
          </div>
        )
      }
    }
    ```

    4c. Experiment with different _falsy_ values. You will see that setting `productionReady` to `null` or `undefined` has the same effect that setting it to `false` does. Try setting `productionReady` to `0`. You will see that the buttons do not show up -- but the `0` does. See what happens if you use `NaN`.

5. Experiment with using JSX to set a variable value. This step provides another example of how seemlessly JSX and JavaScript can be used together.

    5a. Declare a variable called `themeBar` and default it to `null`. Recall that React will not render `null`.

    5b. Remove the line containing `productionReady` and the `&&` operator and its matching end curly brace.

    5c. Paste the following conditional variable assignment below your declaration and initialization of `themeBar`. It assigns the JSX for the theme buttons to the `themeBar` variable if `productionReady` is `true`.

    ```jsx
    if (productionReady) {
      themeBar = <div style={{marginBottom: "10px"}}>
                   <button>
                    Theme 1
                   </button>
                   <button>
                    Theme 2
                   </button>
                 </div>
    }
    ```

    5d. Replace the JSX for the `div` containing the theme buttons with `{themeBar}`. The JavaScript expression `{themeBar}` will evaluate to `null` when `productionReady` is false, and the buttons will not show up. When `productionReady` is true, React will render the JSX assigned to `themeBar`.


## Exercise Components #7 Static Version

_Note: Move to the  07-static directory for this exercise_

Now that you have seen how to build a React component, we can move on to Step #3 in the "Thinking in React" progression: Build a static version in React.

In the previous exercises, we have worked with a simplified version of the blog. The starting point for this exercise is a static version of the blog that includes the full component hierarchy we discussed back in Step #1. We will walk through the application, reviewing the kinds of elements that should be familiar to you at this point, and introducing a few additional rules and features.

1. In this step we'll review the directory structure and briefly review the utility files that are necessary for the core functionality of this application, but are not relevant to learning React.

```text
components/
  public/
    index.html                    <-- The top-level HTML file for the app
  filler-text.js                  <-- Provides a block of filler text
  theme-utils.js                  <-- generates a palette built around a hue
  index.css                       <-- The shared style sheet for all the versions
  index.js                        <-- bootstraps the Blog component on the page
  src/
    07-static
    ...
    blog-component.js             <-- the top-level component (Blog)
    blog-post-component.js        <-- encapsulates the blog title and post (BlogPost)
    resizing-buttons-component.js <-- buttons to adjust text size (ResizingButtons)
    theme-bar-component.js        <-- container for theme buttons (ThemeBar)
    theme-button-component.js     <-- buttons for setting blog palette (ThemeButton)
```

The `filler` utility in `filler-text.js` returns the scrambled version of an ancient Latin text by Cicero that is commonly used as a placeholder by graphic designers.

The `theme-colors` utility in `theme-utils.js` takes a number representing a hue as an argument and generates a palette consisting of a blog post color, a headline color and a background color, based on the hue, saturation and luminance model. It adds 200 to the base hue to generate the headline color, 150 to the base hue to determine the text color and 275 to the hue to generate the background color.

2. In this step we'll walk through the `ThemeBar` component and its constituent `ThemeButton` components. Along the way, we'll talk about how React recommends that you to specify a `key` for each item in a collection.

    2a. Before we open `theme-bar-component.js`, open its parent component, `blog-component.js`, to look at at the `props` it receives. The following snippets from the `Blog` class definition (the `ThemeBar` tags and the variable declarations for the variables assigned to those `props`) show the `props` that are passed to the `ThemeBar` component and their values.

    ```jsx
    const HUES = [3, 125, 210];
    ...
    this.hue = 3;
    ```

    ```jsx
    <ThemeBar chosenHue={this.hue} hues={HUES}/>
    ```

    Open `theme-bar-component.js` and take a look at its `render` method. Notice that the `ThemeBar` component

    Using `map`, the `ThemeBar` loops through the collection of hues and generates a corresponding `ThemeButton` element for each hue. The `map` function yields an array of `ThemeButton` elements.

    ```jsx
    render() {

      const {hues, chosenHue} = this.props;

      return (
        <span style={{width: "150px", marginRight:"40px"}}>

          {hues.map((hue) => {
            return (<ThemeButton
                   chosenHue={chosenHue}
                   label={hues.indexOf(hue) + 1}
                   hue={hue}
                   theme={themeColors(hue)}>
                  </ThemeButton>)
          })}
        </span>
      )
    }
    ```

    Open the console. You will see a warning like the following: `Warning: Each child in an array or iterator should have a unique "key" prop.`

    React uses those keys to help optimize performance. React uses these developer-provided keys to determine whether a new element has been added to the collection and therefor needs to be rendered.

    Add a key `prop` to the JSX that generates the `ThemeButton` element and assign the value of the `hue` to it.

    After you save, the error message should be gone.

3. In this step we'll change the appearance of the application some more by changing the values of props in parent components and we'll walk through the `ResizingButtons` component. Open `resizing-buttons-components.js`.

The `size` prop it receives from the parent component represents the size of the blog post font.

It uses the JavaScript expressions to keep the button label text in sync with the blog post font size and to ensure that the button becomes disabled when `size` dips below 10.

```javascriptblack
<button disabled={size <= 10}>
  Reduce to {size - 10}
</button>
```

Experiment with changing the value of the `size` prop in the `Blog` parent component. If you set size to less than or equal to ten, you will see that the button label turns red, which is the style for `disabled` elements in `index.css`.

4. In this step we'll review the reasons why building a static version is an important part of "Thinking in React".

* It enforces separation between display logic from user interaction logic.
* It structures your application in such a way that its very easy to reason about. Each component is comparable to a pure function in that it always displays the same way when it is passed the same `props` values.
* It drives home the idea that any changes are driven from further up in the hierarchy.
* The biggest difference between `props` and state is that `props` do not change through out the life of the running application and state does. Building a static version in React without state as a separate step underscores this difference.
* It makes it easy to determine the props are being consumed properly in the child components.


## Exercise Components #8 Identify Representation of State

"Thinking in React" provides a list of questions you can ask yourself about each data point in your application to help you arrive at the smallest possible representation of `state`. In this exercise we'll apply that test to each data point and end up with a list of keys for the `state` object we'll introduce into the application in the next step.

The questions are:

  * Is it passed in from a parent via props?
  * Does it remain unchanged over time?
  * Can you compute it based on any other state or props in your component?

Answers:

1. Border color, text Color and label color are not part of `state` because they can be computed (using the themes utility) based on the selected `hue`.

2. Text size IS part of `state` because it can change during runtime and it cannot be computer based on any other `state` or `props`.

3. Selected hue IS part of `state` because it can change during runtime and it cannot be computer based on any other `state` or `props`.

4. Headline size is not part of `state` because it is calculated by added 30 to the blog post text size.

5. The HUES array is not part of `state` because there is no way to change it via the application.

So, state can minimally be represented by the following object:

```jsx
{
  selectedHue: 3,
  size: 20,
}
```

## Exercise Components #9 Where should `state` be managed?

_Note: Keep using 07-static directory for this exercise_

In this exercise we'll determine where `state` should live.

You can start with the farthest downstream components that uses `state`. In keeping with React's "top-down/one way", try to determine if the downstream components that use `state` have a common parent at the next level up the hierarchy. If not, move further up the hierarchy.

In the case of this blog application, the `BlogPost` gets configured based on `state`, and the `ThemeBar` and `ResizingButtons` at that same level are also look to state to determine their appearance. The `Blog` component is their common ancestor.

So `state` will be managed by the `Blog` component.

Once you determine which component should manage `state`, you need to initializing `state` in that component, and then modify the code where `props` are passed to set them based on `state`.

1. In the constructor for the `Blog` component in `blog-component`, replace this:

     ```jsx
     this.size = 20;
     this.hue = 3;
     ```

    ... with this code that initializes `state` ...

    ```jsx
    this.state = {
      hue:3,
      size: 20
    };
    ```

2. Use `state` to set `props` values for the `Blog`'s child components as follows:


    ```jsx
    <ThemeBar chosenHue={this.state.hue} hues={HUES}/>
    <ResizingButtons size={this.state.size}/>
    <BlogPost theme={themeColors(this.state.hue)}
               size={this.state.size}
               text={filler()}
               title="Loren Ipsum"/>
    ```

3. Experiment with changing `state` in the `Blog` component controller and confirm that the downstream components respond.


## Exercise Components #10 Inverse Data Flow

_Note: Use the 10-top-down directory for this exercise_

In this step, we'll wire up event handlers for the theme buttons based on the event handlers that are already in place for the
resizing buttons.

In keeping with top-down logic flow design principle, `state` should only be modified in the top-level component where it lives. The canonical way to handle this in React is to implement change handlers that modify state in the top-level component and pass them to the downstream components where the UI widgets (such as buttons) live, as `props`. In the downstream components, such as the theme buttons, implement bind the onclick events to onClick handlers that do nothing more than wrap the change handlers passed down from the top-level component that manages state.

Although it appears that initializing the `state` values is no different than initializing any other object -- but `state` requires special handling. Instead of modifying `state` directly using the assignment operator, we `setState`, and pass it an object in which the key is the key paired with the value that needs to change and the value is the value for that key. The `setState` function takes an optional argument as well, but we will cover that in a future exercise.

By enforcing the top-down logic flow principle and re-rendering based on `props` when `state` changes, React eliminates control flow, let alone messy control flow with cyclomatic complexity, from event handlers.

1. Implement a theme change handler in `blog-component.js` as follows.

     Notice that it does not use the assignment operator to modify the `state` object. Although it appears that there is no difference between the way the `state` object is initialized in the `Blog` component constructor and the way any other object might be initialized. `state` requires special handling. Use `setState` to change the state. For this exercise, we are just going to pass it an object with a single key/value pair -- the key is `hue`, and the value is the new hue. But in the next set of exercises, we'll look at the optional arguments to `setState`, and we'll take about using immutable vs mutable objects to store `state`.

    ```javascriptblack

    themeChangeHandler(newHue) {
       this.setState({hue:  newHue});
    }

    ````

2. In the constructor, bind `this.themeChangeHandler` to 'this' as follows:

    ```javascriptblack
    this.themeChangeHandler = this.themeChangeHandler.bind(this);
    ```

3. Pass the `themeChangeHandler` to the `ThemeBar` component in `theme-bar-compeont.js` via `props`.

    ```jsx
     <ThemeBar chosenHue={this.state.hue}
               themeChangeHandler={this.themeChangeHandler}/>
    ```

4. Pass the  `themeChangeHandler` to the `ThemeButton` components in `theme-button-component.js` via `props`.

    ```jsx

    const {hues, chosenHue, themeChangeHandler} = this.props;
    ...
    (<ThemeButton
          themeChangeHandler={themeChangeHandler}
          chosenHue={chosenHue}
          label={hues.indexOf(hue) + 1}
          hue={hue}
          theme={themeColors(hue)}>
    </ThemeButton>)
    ```

5. In `theme-button-component.js`, implement an `onClickHandler` that passes the button's base `hue` to the `themeChangeHandler` the button received from the top-level `Blog` component.

    ```javascriptblack
    onClickHandler() {
      this.props.themeChangeHandler(this.props.hue);
    }
    ```

6. Bind the button's `click` event to the local `onClickHandler` that calls out to the `themeChangeHandler` pass in by the top-level `Blog` component.

    ```jsx
    <button onClick={this.onClickHandler}            
            style={{
             color: theme.color,
             borderColor: theme.headlineColor,
             backgroundColor: theme.backgroundColor
            }} className="theme-button">
    <span style={{textDecoration: hue === chosenHue ? "underline" : ""}}>
      Theme #{this.props.label}
    </span>
    </button>
    ```
