import React from 'react';
import Hidden from '@material-ui/core/Hidden';

const UDHidden = (props) => {
    return (
        <Hidden {...props} key={props.id}>
            { props.children && UniversalDashboard.renderComponent(props.children)}
        </Hidden>
    )
}

export default UDHidden; 