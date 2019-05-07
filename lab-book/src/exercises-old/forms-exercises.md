# Forms: Exercises

We're going to use the `forms` project for these exercises.

These exercises use a version of the Blog application that enables the user to set the theme by entering numbers that
represent a hue into a form field. As the user types, the form theme changes to show the user what the blog there will
look like when the user hits "Submit".

## Exercise Forms #1 "Controlled" Form

_Note: This exercise uses the root directory `src/01-controlled` in the `forms` react application._

For the controlled approach, state is the single source of truth .Set each widgets value property based on `state`.
Every user interaction needs to be covered by a handler that calls `setState`.

1. When you first run the application, you will not be able to type in the input field. Try to. 

    You will see the following warning in the console: 
    warning.js:36 Warning: Failed form propType: You provided a `value` prop to a form field without an `onChange` handler. This will render a read-only field. If the 
    field should be mutable use `defaultValue`. Otherwise, set either `onChange` or `readOnly`. 

    Replace the `onBlur` property with `onChange`

2. Set a default value for the input field based on `props`. It is not okay to modify props, but it is okay to initialize (modifiable) state with props.

    ```jsx
    this.state = {
      hue: this.props.hue
    };
    ```

3. Implement the change handler to update `hue` in the state when every the user types into the input field. You can use `event.target` to
access the field and `event.target.value` to get its value.

    ```jsx
    changeHandler(event) {
      this.setState({hue: event.target.value});
    }
    ```

4. Implement the submit handler to call the `themeChangeHandler` passed in by the parent function. Confirm that when you hit submit, the `Blog` theme changes to match the form.

    ```
    submitHandler(event) {
      this.props.themeChangeHandler(this.state.hue);
      event.preventDefault();
    }
 
    ```

5. Try using the theme buttons to change the theme after you change the theme to a custom theme using the form. Notice that the form colors do not change to match the 
Blog. Implement `componentWillReceiveProps` so that the themes for the form and blog stay in sync.

    ```jsx
    componentWillReceiveProps(newProps) {
      this.setState({hue: newProps.chosenHue});   
    }
    ```

6. Implement some error handling. Add error to `state`

    ```jsx
    this.state = {
      hue: "",
      error: ""
    };
    ```

7. Add JSX to display the error, if the validation we are going to add finds an error

    ```jsx       
     <span>  {this.state.error}</span>
    ```

8. Modify the `changeHandler` to set an error message if the user enters "44", which will 
turn the background red:

    ```jsx
    changeHandler(event) {
      this.setState({hue: event.target.value});
      if (event.target.value == 44) {
        this.setState({error: "INVALID HUE: RESERVED FOR ERROR MESSAGES"});
      } else {
        this.setState({error: ""});
      }
    }
    ```

9. Disable the submit button if there is an error, but setting `disabled` to true if there is an error message

    ```
    disabled={this.state.error.length > 0}
    ```

10. Try swapping out the text field and using a select box instead

    ```jsx
    <select value={this.state.hue} onChange={this.changeHandler}
     style={{color: theme.backgroundColor, backgroundColor: theme.color}}>
                                <option value="210">210</option>
                                <option value="3">3</option>
                                <option value="125">125</option>
    </select

    ```

## Exercise Forms #2 "Uncontrolled" Form

For uncontrolled forms, the `submit` handler needs to inspect DOM elements directly to get the values it needs. You can make
DOM elements accessible to the React component class by using the `ref` property.

1.  Bind a function that specifies a handle to the `ref` property. You can use `hueField` as the handle for the input field. 

    ```jsx
    ref={(hueField) => this.hueField = hueField}
    ```

2. The function passed to `ref` is called after the component mounts. You therefor have direct access to that DOM element 
any time after that point in the component's lifecycle.

Use the `hueField` handle to set focus to the field in `componentDidMount`.

    ```jsx
    componentDidMount() {
      this.hueField.focus();
    }
    ```

3. Implement the submit handler to call the `themeChangeHandler` passed in by the parent function. You will
need to use the `hueField` handle to access the field. Pass its `value` to the theme change handler. 
Confirm that when you hit submit, the `Blog` theme changes to match the form.

    ```jsx
    submitHandler(event) {
      this.props.themeChangeHandler(this.hueField.value);
      event.preventDefault();
    }
    ```
