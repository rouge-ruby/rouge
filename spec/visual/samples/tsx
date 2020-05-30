import * as React from 'react';
import * as ReactDOM from 'react-dom';

const myDivElement = <div className="foo" />;
ReactDOM.render(myDivElement, document.getElementById('example'));

class MyComponent extends React.Component<{someProperty?: any, thing?: any}, void> {
    static staticThing;
}

let myElement: React.ReactElement<MyComponent>;
myElement = <MyComponent someProperty={true} />;
ReactDOM.render(myElement, document.getElementById('example'));

myElement = <MyComponent someProperty={{a:true}.a} />;
myElement = <MyComponent someProperty={function() {
  var x = { a: true };
  return x.a;
}} />

const thing = {otherThing: 0};

thing.otherThing<MyComponent.staticThing // comment - this is comparison
myElement = (
  <MyComponent thing={thing.otherThing>2}>
    hello, world!
  </MyComponent>
);

class Container extends React.Component<void, void> {}
class Nav extends React.Component<void, void> {}
class Login extends React.Component<void, void> {}
class Person extends React.Component<{name: string}, void> {}
var content = <Container>{window.isLoggedIn ? <Nav /> : <Login />}</Container>;

// These two are equivalent in JSX for disabling a button
<input type="button" disabled />;
<input type="button" disabled={true} />;

// And these two are equivalent in JSX for not disabling a button
<input type="button" />;
<input type="button" disabled={false} />;

var content = (
  <Nav>
    {/* child comment, put {} around */}
    a slash-star that isn't a comment because this is html: /*
    <Person
      /* multi
         line
         comment */
      name={window.isLoggedIn ? window.name : ''} // end of line comment
    />
  </Nav>
);

class A extends React.Component<{b: void}, void> {}
class D extends React.Component<{e: boolean}, void> {}
<A b={function() { var c = <D e={true}>&quot;</D>; }()}/>

class LikeButton extends React.Component<void, {liked: boolean}> {
  public state = {
    liked: false,
  }

  private handleClick = () => {
    this.setState({liked: !this.state.liked});
  }

  public render() {
    const text = this.state.liked ? 'liked' : 'haven\'t liked';
    return (
      <div onClick={this.handleClick}>
        You {text} this. Click to toggle.
      </div>
    );
  }
}

ReactDOM.render(
  <LikeButton />,
  document.getElementById('example')
);
