---
title: ECMAScript - Lab
header-includes:
    - \usepackage{fancyhdr}
    - \pagestyle{fancy}
    - \fancyfoot[CO,CE]{\thepage}
    - \fancyfoot[LO,RE]{Chariot Solutions, 2016}
    - \fancyfoot[LE,RO]{React and Friends, v1.0 12/2/2016}
---
# ECMAScript Lab - ES5, ES2015 and ES2016

This lab will introduce you to the power of modern JavaScript (at least at the time of this publication)!

The ECMAScript TC-39 committee defines the current language specification, properly known as ECMAScript, and has a number of versions in its history:

* ES1, ES2, ES3 - legacy, no longer used
* ES4 - never actually made it into widespread use
* ES5 - Released in 2009
* ES6 (known as ES.Next, now ES2015) - adoption has begun in NodeJs, some browsers such as Chrome, Firefox, Edge
* ES2016 - the next feature drop of ECMAScript, is limited in scope
* ES2017 - future specifications emerging, not approved yet.

Each new feature goes through a series of stages, from stage 0 to stage 4. See [The TC39 Process at https://tc39.github.io/process-document/](https://tc39.github.io/process-document/) for details.

##  Experimenting with modern JavaScript

Open a command line and switch to the `lab/es-experiments` directory.  Set up the project dependencies using the following command:

     npm install

The project contains a series of source files, written in ES2015 and above syntax, which is what our training course build script will accept. The modern source files are contained in `src/es`.

You will use Babel Node to run your ES2015/2016 code snippets. Later we'll run the file-based transpiler so you can see how the modern JavaScript code looks once converted to ES5.

Let's try a few experiments.

### Experiment with ECMASCript syntax - Exercises

1. Write a simple class for a `Customer` that provides a `name` property and a `sayGreeting` method using a provided string, and the name of the customer to print out a greeting in the console. Store this as `src/es/class.js`.

    ```javascriptblack
    export class Customer extends Printable {
        constructor(name) {
          this.name = name;
        }

        sayGreeting(greeting) {
          console.log(`${greeting}, ${this.name}`);
        }
    }
    ```

    At the end of this class definition, test it with the following code:

    ```javascriptblack
    const customer = new Customer('ABC Corp');
    console.log(customer.sayGreeting('Salutations!'));
    ```

    Next, execute the code using the following command from the root of the project in a command line:

    ```bash
    npm run exec src/es/class.js
    ```

    The console should print `Salutations, ABC Corp!`.

2. Now let's take a look at some arrow functions. First, create a file named `arrows.js` in `src/es`.  Put a simple expression-based `reduce` function in the file:

    ```javascriptblack
    const data = [1, 6, 3, 5, 6, 3];
    const sum = data.reduce((x, prev) => prev + x, 0);
    console.log(`The sum is ${sum}`);
    ```

    The arrow function embedded in the `Array.prototype.reduce` method call executes for each entry of the array. The simple expression, `prev + x`, is evaluated and returned for each element, as it is the only expression pointed to in the Arrow function.

    In this way, any one-line function can be collapsed to the form of `(args) => expression`.

    Run this sample with `npm run exec src/es/arrows.js` and make sure it outputs a total of `24`.

    You can review the ES5 syntax by executing `npm run build` and reviewing `src/js/arrows.js`. It looks like this:

    ```javascriptblack
    "use strict";

    var data = [1, 6, 3, 5, 6, 3];
    var sum = data.reduce(function (x, prev) {
      return prev + x;
    }, 0);
    console.log("The sum is " + sum);
    ```

2. Next, we'll review an interesting feature of the ES2015 browser API for `Array` - the `from` function. It lets you fill in a series of array values. In the case we're using we'll ask it to take a source array, and convert the values to another array, essentially mapping over it to transform it.

    Create a file `arrays-feature.js` in `src/es` and fill it with the following code snippet:

    ```javascriptblack
    console.log(
      Array.from([1, 2, 3, 5, 6, 6], v => v * 123)
    );
    ```

    Run it with `npm run exec src/es/arrays-feature.js`. You'll see it transform the array by multiplying each element by 123.

2. Now we'll experiment with ECMAScript modules. The module feature allows for separation of JavaScript code by feature, without forcing the developer to mount each script in the browser with a script tag.

    In this example, we're letting Babel use the NodeJS Require API, whereas in a React application we'll use Webpack's module system instead. No matter, the syntax from the JavaScript file perspective will be the same. It's just a runtime distinction.

    First, let's create our exportable function, `sayHello`, placing the following source code in `src/es` as `export-function.js`:

    ```javascriptblack
    export function sayHello() {
      console.log('hello!');
    }
    ```

    Next, create a file that uses this module, `import-function.js`, with the following contents:

    ```javascriptblack
    import {sayHello} from './export-function.js';
    sayHello();
    ``` 

    Run the `import-function.js` file with `npm run exec src/es/import-function.js` and watch the console output the greeting from the imported module's function.

2.  Next, we'll experiment with a new feature in `ES2016` - the `Object` methods `values` and `entries` join the `keys` function in this version.  With each one, you will get the values, or the key and value, as a series of array elements.

    Create a file, `object-values-entries.js`, in `src/es` and fill it with:

    ```javascriptblack
    const thing = {
      a: 1234,
      b: 'hi there',
      c: new Date()
    };
    let keys = Object.keys(thing); // ES5
    let values = Object.values(thing); // ES2016
    let entries = Object.entries(thing);// ES2016
    console.log(`Thing keys: ${keys}`);
    console.log(`Thing values: ${values}`);
    console.log(`Thing entries: ${entries}`);
    ```

    As before, execute `npm run exec src/es/object-values-entries.js` and see how each of the function renders output.

2. Finally, we're going to review a sample class that shows off the plusses and minuses of the arrow function when it comes to dealing with asynchronous calls.

    Run the file `src/es/this-is-fun.js`, which is already filled out for you.  The command is `npm run exec src/es/this-is-fun.js`.  The output is:

    ```bash
    Without arrow - message is undefined
    With arrow - message is I am a message
    With arrow and saved self  - message is I am a message
    Without arrow and saved self  - message is I am a message
    ```

    Background: ES2015 introduces the arrow function, which has one interesting side-effect: it preserves the `this` keyword if run on a _synchronous block of code_. However, the key word is `synchronous`. 

    In an asynchronous block of code, like a `setTimeout` function, the browser will perform a callback to the function supplied by the timeout after the supplied timeout period. The `this` keyword may _no longer be the object it was written in`, however. It will be, in this case, `window`.

    The sample contains a class with a single member variable, `message`. The setup is simple enough:

    ```javascriptblack
    class DoThingsAsync {
      constructor(message) {
        this.message = message;
      }
      ...
    }
    ```

    In each method, we try to kick off a method one second after calling a function, which will force it to be asynchronous. In this first sample, we don't preserve the `this` keyword, so we lose the context:

    ```javascriptblack
     asyncWithoutArrow() {
        setTimeout(function() {
            console.log(`Without arrow - message is ${this.message}`);
        }, 1000);
    }
    ```

    So in that case, we get `undefined` for the output.

    But there is a way to keep this from happening. In methods like `setTimeout` we can save off `this` automatically by using an _arrow_ function:

    ```javascriptblack
    asyncWithArrow() {
        setTimeout(() => {
            console.log(`With arrow - message is ${this.message}`);
        }, 1000);
    }
    ```

    When running this method, we get the message on output. The arrow function works well with the `this` keyword when dealing with functions that are defined in a surrounding context like the one above.

    In some cases, you won't be able to get the `this` context variable working without saving it off, so eve in those circumstances saving off `this` to a variable like `self` is useful. This is especially true of functions that resolve a promise.  Here's an example of doing that in an arrow function:


    ```javascriptblack
    asyncSaveThisWithArrow() {
        const self = this;
         setTimeout(() => {
            console.log(`With arrow and saved self - This is ${JSON.stringify(this)}`);
            console.log(`With arrow and saved self  - message is ${self.message}`);
        }, 1000);

    }
    ```

    We'll cover that situation specifically later in the course. 

## Wrap-up

Feel free to use this project throughout the course to experiment with various ES2015/2016 features. Just drop a file in `src/es` and run `npm run build` to view the output or `npm run exec src/es/filename.js` to execute it in NodeJs.
