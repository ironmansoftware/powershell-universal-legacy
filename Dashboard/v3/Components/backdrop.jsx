import React from 'react';
import { Backdrop } from '@material-ui/core';
import { withComponentFeatures } from 'universal-dashboard';
import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ({
    backdrop: props => ({
      zIndex: theme.zIndex.drawer + 1,
      color: props.color,
    }),
  }));
  

function UDBackdrop(props) {
    const classes = useStyles(props);

    return <Backdrop open={props.open} className={classes.backdrop} onClick={() => props.onClick()}>{props.render(props.children)}</Backdrop>
}

export default withComponentFeatures(UDBackdrop);