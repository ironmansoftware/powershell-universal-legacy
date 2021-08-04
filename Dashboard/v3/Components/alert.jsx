import React from 'react';
import { Alert, AlertTitle } from '@material-ui/lab';
import { withComponentFeatures } from 'universal-dashboard';

function UDAlert(props) {
    return <Alert severity={props.severity} key={props.id} id={props.id}>
        {props.title && props.title !== "" ? <AlertTitle>{props.title}</AlertTitle> : <React.Fragment />}
        {props.render(props.children)}
    </Alert>
}

export default withComponentFeatures(UDAlert);