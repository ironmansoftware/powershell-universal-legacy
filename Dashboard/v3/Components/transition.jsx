import React from 'react';
import { Collapse, Slide, Zoom, Grow, Fade } from '@material-ui/core';
import { withComponentFeatures } from 'universal-dashboard';

function Transition(props) {
    if (props.transition === "fade")
    {
        return <Fade timeout={props.timeout} in={props.in}>
            {props.render(props.children)}
        </Fade>
    }

    if (props.transition === "zoom")
    {
        return <Zoom timeout={props.timeout} in={props.in}>
            {props.render(props.children)}
        </Zoom>
    }
    
    if (props.transition === "grow")
    {
        return <Grow timeout={props.timeout} in={props.in}>
            {props.render(props.children)}
        </Grow>
    }

    if (props.transition === "slide")
    {
        return <Slide timeout={props.timeout} in={props.in} direction={props.slideDirection}>
            {props.render(props.children)}
        </Slide>
    }

    if (props.transition === "collapse")
    {
        return <Collapse timeout={props.timeout} in={props.in} collapsedHeight={props.collapsedHeight}>
            {props.render(props.children)}
        </Collapse>
    }
}

export default withComponentFeatures(Transition);