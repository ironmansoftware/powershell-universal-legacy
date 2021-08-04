import React from 'react';
import { css } from 'emotion';

export default class UDStyle extends React.Component {
  render() {

    var children = this.props.content;
    if (!Array.isArray(children))
    {
        children = [children];
    }

    children = children.map(x => UniversalDashboard.renderComponent(x));

    const style = css(this.props.style);

    return (
      React.createElement(this.props.tag, {className: style}, children)
    );
  }
}