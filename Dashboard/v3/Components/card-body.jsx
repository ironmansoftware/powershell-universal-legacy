import React, { Fragment } from "react";
import { withStyles, CssBaseline, CardContent } from "@material-ui/core";
import classNames from "classnames";

const styles = theme => ({
  content: {
    display: "flex"
  }
});

export class UDCardBody extends React.Component {
  render() {
    const {
      className,
      classes,
      id,
      style
    } = this.props;

    return (
      <Fragment>
        <CssBaseline />

        <CardContent
          id={id}
          key={id}
          className={classNames(classes.content, className, "ud-mu-cardbody")}
          style={{ ...style }}>
          {UniversalDashboard.renderComponent(this.props.content)}
        </CardContent>
      </Fragment>
    );
  }
}

export default withStyles(styles)(UDCardBody);
